import Foundation

struct UserNFTRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        var components = URLComponents(string: RequestConstants.baseURL)
        components?.path = "/api/v1/nft/\(id)"
        return components?.url
    }
    var dto: Dto? {
        return nil
    }
}
struct NFTListRequest: NetworkRequest {
    let ids: [String]
    
    var endpoint: URL? {
        var components = URLComponents(string: RequestConstants.baseURL)
        components?.path = "/api/v1/nft"
        
        let nftsString = ids.joined(separator: ",")
        components?.queryItems = [
            URLQueryItem(name: "ids", value: nftsString)
        ]
        return components?.url
    }
    
    var dto: Dto? {
        return nil
    }
}
