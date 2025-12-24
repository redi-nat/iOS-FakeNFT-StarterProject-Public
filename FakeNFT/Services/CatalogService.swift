import Foundation

protocol CatalogServiceProtocol {
    func loadCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void)
}

final class CatalogService: CatalogServiceProtocol {
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
    }
    
    func loadCollections(completion: @escaping (Result<[CollectionModel], Error>) -> Void) {
        let request = CollectionsRequest()
        
        networkClient.send(request: request, type: [CollectionModel].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
