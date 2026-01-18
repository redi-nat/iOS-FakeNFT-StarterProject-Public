import Foundation

typealias CurrenciesCompletion = (Result<[Currency], Error>) -> Void

protocol CurrencyService {
    /// Загружает список доступных валют
    func loadCurrencies(completion: @escaping CurrenciesCompletion)
}

final class CurrencyServiceImpl: CurrencyService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCurrencies(completion: @escaping CurrenciesCompletion) {
        let request = GetCurrenciesRequest()
        networkClient.send(request: request, type: [Currency].self) { result in
            switch result {
            case .success(let currencies):
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

