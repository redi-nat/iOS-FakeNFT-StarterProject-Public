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
    
    func updateOrder(nftIds: [String], completion: @escaping CartCompletion)
    func loadNFT(id: String, completion: @escaping (Result<CartNFT, Error>) -> Void)
}

final class CartServiceImpl: CartService {
    func addNFT(id: String, completion: @escaping CartCompletion) {
        
    }
    
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadCart(completion: @escaping CartCompletion) {
        networkClient.send(request: GetCartRequest(), type: Order.self, completionQueue: .main, onResponse: completion)
    }
    
    func updateOrder(nftIds: [String], completion: @escaping CartCompletion) {
        let request = UpdateCartRequest(nftIds: nftIds)
        networkClient.send(request: request, type: Order.self, completionQueue: .main, onResponse: completion)
    }
    
    func removeNFT(id: String, completion: @escaping CartCompletion) {
    }
    
    func clearCart(completion: @escaping CartCompletion) {
        updateOrder(nftIds: [], completion: completion)
    }
    
    func loadNFT(id: String, completion: @escaping (Result<CartNFT, Error>) -> Void) {
        let request = NFTDetailRequest(id: id)
        networkClient.send(request: request, type: CartNFT.self, completionQueue: .main, onResponse: completion)
    }
}

