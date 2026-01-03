import Foundation

struct UsersRequest: NetworkRequest {
    let page: Int
    let size: Int
    
    init(page: Int = 0, size: Int = 20) {
        self.page = page
        self.size = size
    }
    
    var endpoint: URL? {
        var components = URLComponents(string: RequestConstants.baseURL + "/api/v1/users")
        components?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)")
        ]
        
        let url = components?.url
        print("🌐 URL запроса: \(url?.absoluteString ?? "nil")")
        
        return url
    }
    
    var dto: Dto? {
        return nil
    }
}

struct UserRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        var components = URLComponents(string: RequestConstants.baseURL)
        components?.path = "/api/v1/users/\(id)"
        
        return components?.url
    }
    
    var dto: Dto? {
        return nil
    }
}
