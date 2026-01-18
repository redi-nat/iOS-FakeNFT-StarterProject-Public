import Foundation

enum NetworkClientError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case parsingError
}

protocol NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              completionQueue: DispatchQueue,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask?

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            completionQueue: DispatchQueue,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask?
}

// Дефолтные значения очереди, чтобы не писать .main каждый раз
extension NetworkClient {
    @discardableResult
    func send(request: NetworkRequest,
              onResponse: @escaping (Result<Data, Error>) -> Void) -> NetworkTask? {
        send(request: request, completionQueue: .main, onResponse: onResponse)
    }

    @discardableResult
    func send<T: Decodable>(request: NetworkRequest,
                            type: T.Type,
                            onResponse: @escaping (Result<T, Error>) -> Void) -> NetworkTask? {
        send(request: request, type: type, completionQueue: .main, onResponse: onResponse)
    }
}

struct DefaultNetworkClient: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = URLSession.shared,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    @discardableResult
    func send(
        request: NetworkRequest,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<Data, Error>) -> Void
    ) -> NetworkTask? {
        guard let urlRequest = create(request: request) else { return nil }

        // ЛОГ 1: Что отправляем
        print("📡 ОТПРАВКА: [\(request.httpMethod.rawValue)] \(urlRequest.url?.absoluteString ?? "")")
        if let body = urlRequest.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 ТЕЛО ЗАПРОСА: \(bodyString)")
        }

        let task = session.dataTask(with: urlRequest) { data, response, error in
            let result: Result<Data, Error>
            
            if let error = error {
                print("❌ ОШИБКА СЕТИ: \(error.localizedDescription)")
                result = .failure(NetworkClientError.urlRequestError(error))
            } else if let response = response as? HTTPURLResponse {
                print("⬅️ ОТВЕТ: [\(response.statusCode)] \(urlRequest.url?.absoluteString ?? "")")
                
                if !(200..<300).contains(response.statusCode) {
                    if let data = data, let serverMsg = String(data: data, encoding: .utf8) {
                        print("⚠️ СООБЩЕНИЕ СЕРВЕРА: \(serverMsg)")
                    }
                    result = .failure(NetworkClientError.httpStatusCode(response.statusCode))
                } else if let data = data {
                    result = .success(data)
                } else {
                    result = .failure(NetworkClientError.urlSessionError)
                }
            } else {
                result = .failure(NetworkClientError.urlSessionError)
            }

            completionQueue.async { onResponse(result) }
        }

        task.resume()
        return DefaultNetworkTask(dataTask: task)
    }

    @discardableResult
    func send<T: Decodable>(
        request: NetworkRequest,
        type: T.Type,
        completionQueue: DispatchQueue,
        onResponse: @escaping (Result<T, Error>) -> Void
    ) -> NetworkTask? {
        return send(request: request, completionQueue: completionQueue) { result in
            switch result {
            case let .success(data):
                self.parse(data: data, type: type, onResponse: onResponse)
            case let .failure(error):
                onResponse(.failure(error))
            }
        }
    }

    // MARK: - Private

    private func create(request: NetworkRequest) -> URLRequest? {
        guard let endpoint = request.endpoint else { return nil }

        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = request.httpMethod.rawValue
        urlRequest.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")

        if let dtoDictionary = request.dto?.asDictionary() {
            // Ручная сборка body, чтобы избежать проблем с кодированием запятых
            let bodyString = dtoDictionary.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
            urlRequest.httpBody = bodyString.data(using: .utf8)
            urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }

    private func parse<T: Decodable>(data: Data, type: T.Type, onResponse: @escaping (Result<T, Error>) -> Void) {
        do {
            let response = try decoder.decode(T.self, from: data)
            onResponse(.success(response))
        } catch {
            print("🧩 ОШИБКА ПАРСИНГА \(T.self): \(error)")
            if let rawString = String(data: data, encoding: .utf8) {
                 print("📄 СЫРЫЕ ДАННЫЕ ОТ СЕРВЕРА: \(rawString)")
            }
            onResponse(.failure(NetworkClientError.parsingError))
        }
    }
}
