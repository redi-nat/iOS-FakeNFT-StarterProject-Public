import Foundation

typealias PaymentCompletion = (Result<PaymentResponse, Error>) -> Void

protocol PaymentService {
    /// Отправляет запрос на оплату заказа
    /// - Parameters:
    ///   - orderId: ID заказа (обычно "1")
    ///   - currencyId: ID выбранной валюты
    ///   - completion: Callback с результатом операции
    func payOrder(orderId: String, currencyId: String, completion: @escaping PaymentCompletion)
}

final class PaymentServiceImpl: PaymentService {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func payOrder(orderId: String, currencyId: String, completion: @escaping PaymentCompletion) {
        let request = PaymentRequest(orderId: orderId, currencyId: currencyId)
        networkClient.send(request: request, type: PaymentResponse.self) { result in
            switch result {
            case .success(let paymentResponse):
                completion(.success(paymentResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

