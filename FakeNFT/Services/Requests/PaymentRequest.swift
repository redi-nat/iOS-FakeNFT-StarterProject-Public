import Foundation

/// Запрос для оплаты заказа
struct PaymentRequest: NetworkRequest {
    let orderId: String
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)/payment/\(currencyId)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}

/// Ответ на запрос оплаты
struct PaymentResponse: Decodable {
    let success: Bool
    let orderId: String
}

