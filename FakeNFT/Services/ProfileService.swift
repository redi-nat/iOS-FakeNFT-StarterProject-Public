import Foundation

typealias ProfileCompletion = (Result<Void, Error>) -> Void

/// Сервис для работы с профилем пользователя
/// ВАЖНО: Это заглушка для интеграции с профилем. Будет доработано при слиянии веток.
protocol ProfileService {
    /// Добавляет купленные NFT в профиль пользователя
    /// - Parameters:
    ///   - nftIds: Массив ID купленных NFT
    ///   - completion: Callback с результатом операции
    func addPurchasedNFTs(_ nftIds: [String], completion: @escaping ProfileCompletion)
}

final class ProfileServiceImpl: ProfileService {
    
    private let networkClient: NetworkClient
    private let nftStorage: NftStorage
    
    // ВРЕМЕННОЕ ХРАНИЛИЩЕ ДЛЯ ЗАГЛУШКИ - TODO: Удалить после интеграции с профилем
    private var purchasedNFTIds: [String] = []
    
    init(networkClient: NetworkClient, nftStorage: NftStorage) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    func addPurchasedNFTs(_ nftIds: [String], completion: @escaping ProfileCompletion) {
        // ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ТЕСТИРОВАНИЯ
        // TODO: Реализовать реальную логику при интеграции с профилем
        
        // Сохраняем ID купленных NFT в заглушку
        purchasedNFTIds.append(contentsOf: nftIds)
        
        // Имитируем задержку сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(()))
        }
        
        // Раскомментировать для реального API:
        /*
        // Здесь будет запрос к API для добавления NFT в профиль
        // Например: PUT /api/v1/profile/nfts с массивом ID
        
        let request = UpdateProfileNFTsRequest(nftIds: nftIds)
        networkClient.send(request: request, type: ProfileResponse.self) { result in
            switch result {
            case .success:
                // Также сохраняем NFT в локальное хранилище для быстрого доступа
                // Загружаем данные NFT и сохраняем в NftStorage
                for nftId in nftIds {
                    // Можно загрузить NFT через NftService и сохранить в NftStorage
                    // или просто сохранить ID для последующей загрузки
                }
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
    }
    
    /// Получить список купленных NFT (для тестирования)
    /// TODO: Удалить после интеграции с профилем
    func getPurchasedNFTIds() -> [String] {
        return purchasedNFTIds
    }
}
