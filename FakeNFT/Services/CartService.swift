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
    
    /// Добавляет NFT в корзину
    /// - Parameters:
    ///   - id: ID NFT для добавления
    ///   - completion: Callback с результатом операции
    func addNFT(id: String, completion: @escaping CartCompletion)
    
    /// Очищает корзину
    /// - Parameter completion: Callback с результатом операции
    func clearCart(completion: @escaping CartCompletion)
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
    
    func addNFT(id: String, completion: @escaping CartCompletion) {
        // ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ТЕСТИРОВАНИЯ - добавление в mock данные
        // TODO: Удалить после проверки ревьювером
        
        // Проверяем, нет ли уже такого NFT в корзине
        guard !mockNFTs.contains(where: { $0.id == id }) else {
            // Если NFT уже есть, просто возвращаем текущую корзину
            let currentOrder = Order(id: "1", nfts: mockNFTs)
            DispatchQueue.main.async {
                completion(.success(currentOrder))
            }
            return
        }
        
        // Создаем новый NFT (в реальном API нужно будет загрузить данные NFT)
        // Для заглушки создаем простой NFT
        let newNFT = CartNFT(
            id: id,
            name: "NFT \(id)",
            images: [],
            rating: 3,
            price: 1.0
        )
        mockNFTs.append(newNFT)
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
                // Проверяем, нет ли уже такого NFT в корзине
                guard !order.nfts.contains(where: { $0.id == id }) else {
                    completion(.success(order))
                    return
                }
                
                // Добавляем новый NFT в список
                let updatedNftIds = order.nfts.map { $0.id } + [id]
                
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
    
    func clearCart(completion: @escaping CartCompletion) {
        // ВРЕМЕННАЯ ЗАГЛУШКА ДЛЯ ТЕСТИРОВАНИЯ - очистка mock данных
        // TODO: Удалить после проверки ревьювером
        
        mockNFTs = []
        let emptyOrder = Order(id: "1", nfts: [])
        
        // Имитируем задержку сети
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion(.success(emptyOrder))
        }
        
        // Раскомментировать для реального API:
        /*
        // Отправляем PUT запрос с пустым списком NFT
        let request = UpdateCartRequest(nftIds: [])
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
}

