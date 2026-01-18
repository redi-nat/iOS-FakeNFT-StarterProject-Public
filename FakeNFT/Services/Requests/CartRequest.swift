import Foundation

/// Запрос для получения корзины
struct GetCartRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .get
    var dto: Dto?
}

/// Запрос для обновления корзины (удаление NFT)
struct UpdateCartRequest: NetworkRequest {
    let nftIds: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto? {
        UpdateCartDto(nftIds: nftIds)
    }
}

/// DTO для обновления корзины
struct UpdateCartDto: Dto {
    let nftIds: [String]
    
    func asDictionary() -> [String: String] {
        if nftIds.isEmpty {
            return [:]
        }
        
        let joinedIds = nftIds.joined(separator: "&nfts=")
        return ["nfts": joinedIds]
    }
}

