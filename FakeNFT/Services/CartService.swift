import Foundation

typealias CartCompletion = (Result<Order, Error>) -> Void

protocol CartService {
    /// Загружает корзину (заказ)
    func loadCart(completion: @escaping CartCompletion)
    
    /// Удаляет NFT из корзины
    /// - Parameters:
    ///   - id: ID NFT для удаления
    ///   - completion: Callback с результатом операции
    func removeNFT(id: String, completion: @escaping CartCompletion)
}

final class CartServiceImpl: CartService {
    
    private let networkClient: NetworkClient
    
    // ВРЕМЕННОЕ ХРАНИЛИЩЕ ДЛЯ ЗАГЛУШКИ - TODO: Удалить после проверки ревьювером
    private var mockNFTs: [CartNFT] = [
        CartNFT(
            id: "1",
            name: "April",
            images: [], // Пустой массив - ячейка будет использовать изображение "April" из Assets
            rating: 4,
            price: 1.5
        ),
        CartNFT(
            id: "2",
            name: "May",
            images: [], // Пустой массив - ячейка будет использовать изображение "April" из Assets
            rating: 5,
            price: 2.3
        )
    ]
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCart(completion: @escaping CartCompletion) {
        // ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ТЕСТИРОВАНИЯ - 2 продукта в корзине
        // TODO: Удалить после проверки ревьювером
        let mockOrder = Order(id: "1", nfts: mockNFTs)
        
        // Имитируем задержку сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion(.success(mockOrder))
        }
        
        // Раскомментировать для реального API:
        /*
        let request = GetCartRequest()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
    }
    
    func removeNFT(id: String, completion: @escaping CartCompletion) {
        // ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ТЕСТИРОВАНИЯ - удаление из mock данных
        // TODO: Удалить после проверки ревьювером
        
        // Удаляем NFT из mock данных
        mockNFTs = mockNFTs.filter { $0.id != id }
        let updatedOrder = Order(id: "1", nfts: mockNFTs)
        
        // Имитируем задержку сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(updatedOrder))
        }
        
        // Раскомментировать для реального API:
        /*
        // Сначала загружаем текущую корзину
        loadCart { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let order):
                // Удаляем NFT из списка
                let updatedNftIds = order.nfts
                    .filter { $0.id != id }
                    .map { $0.id }
                
                // Отправляем PUT запрос с обновленным списком
                let request = UpdateCartRequest(nftIds: updatedNftIds)
                self.networkClient.send(request: request, type: Order.self) { updateResult in
                    switch updateResult {
                    case .success(let updatedOrder):
                        completion(.success(updatedOrder))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        */
    }
}

