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
    
    func fetchNFT(id: String, completion: @escaping (Result<Nft, Error>) -> Void) {
        let request = NFTDetailRequest(id: id)
        print("🚀 Отправка запроса для NFT ID: \(id)")
        
        networkClient.send(request: request, type: Nft.self) { result in
            switch result {
            case .success(let nft):
                print("✅ Успешно загружен NFT: \(nft.name)")
                completion(.success(nft))
            case .failure(let error):
                print("❌ Ошибка загрузки NFT ID \(id): \(error)")
                completion(.failure(error))
            }
        }
    }
}

struct NFTDetailRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "https://d5dn3j2ouj72b0ejucbl.apigw.yandexcloud.net/api/v1/nft/\(id)")
    }
    
    var httpMethod: HttpMethod { .get }
    var dto: Dto? { nil }
}
