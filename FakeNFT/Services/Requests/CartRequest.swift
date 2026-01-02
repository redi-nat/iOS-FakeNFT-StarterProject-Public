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
        // API принимает nfts как строку с ID через запятую
        // Например: "id1,id2,id3"
        let nftsString = nftIds.joined(separator: ",")
        return ["nfts": nftsString]
    }
}

