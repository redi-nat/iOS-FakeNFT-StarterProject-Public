import Foundation

/// Запрос для получения списка валют
struct GetCurrenciesRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}

/// Запрос для получения валюты по ID
struct GetCurrencyByIdRequest: NetworkRequest {
    let currencyId: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies/\(currencyId)")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}

