import Foundation

typealias LikesCompletion = (Result<[String], Error>) -> Void

protocol LikesService {
    func loadLikes(completion: @escaping LikesCompletion)
    func updateLikes(_ likes: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

final class LikesServiceImpl: LikesService {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadLikes(completion: @escaping LikesCompletion) {
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success(let profile):
                completion(.success(profile.likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func updateLikes(_ likes: [String], completion: @escaping (Result<Void,Error>) -> Void) {
        let request = LikeRequest(likes: likes)
        networkClient.send(request: request, type: Profile.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

struct Profile: Decodable {
    let likes: [String]
    let id: String
}

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
    var dto: Dto? {
        return nil
    }
}
