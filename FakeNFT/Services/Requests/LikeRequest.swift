import Foundation

struct LikeRequest: NetworkRequest {
    let likes: [String]
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var httpMethod: HttpMethod = .put
    var dto: Dto?
    
    init(likes: [String]) {
        self.likes = likes
        self.dto = LikesDto(likes:likes)
    }
}

struct LikesDto: Dto {
    let likes: [String]
    func asDictionary() -> [String : String] {
        let likesString = likes.joined(separator: ",")
        return ["likes": likesString]
    }
}
