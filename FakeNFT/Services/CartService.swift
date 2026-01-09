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
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCart(completion: @escaping CartCompletion) {
        let request = GetCartRequest()
        networkClient.send(request: request, type: Order.self) { result in
            switch result {
            case .success(let order):
                completion(.success(order))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeNFT(id: String, completion: @escaping CartCompletion) {
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
    }
    
    func addNFT(id: String, completion: @escaping CartCompletion) {
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
    }
    
    func clearCart(completion: @escaping CartCompletion) {
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
    }
}

