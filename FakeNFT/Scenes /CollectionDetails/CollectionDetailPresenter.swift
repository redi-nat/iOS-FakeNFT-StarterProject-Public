import Foundation

final class CollectionDetailPresenter: CollectionDetailPresenterProtocol {
    
    private weak var view: CollectionDetailViewProtocol?
    private let collection: CollectionModel
    private let service: CatalogService
    private let cartService: CartService
    private var nfts: [Nft] = []
    
    private let likesKey = "LikedNFTsKey"
    private let cartKey = "CartNFTsKey"
    
    private var cartNFTs: Set<String> = []
    private var likedNFTs: Set<String> = []
    
    init(view: CollectionDetailViewProtocol, collection: CollectionModel, service: CatalogService, cartService: CartService) {
        self.view = view
        self.collection = collection
        self.service = service
        self.cartService = cartService
        loadData()
    }
    
    func nft(at index: Int) -> Nft? {
        guard nfts.indices.contains(index) else { return nil }
        return nfts[index]
    }
    
    func viewDidLoad() {
        view?.displayCollectionInfo()
        loadNFTs()
    }
    
    func getCollection() -> CollectionModel {
        return collection
    }
    
    func numberOfItems() -> Int {
        return nfts.count
    }
    
    func isLiked(nftId: String) -> Bool {
        return likedNFTs.contains(nftId)
    }
    
    func toggleLike(nftId: String) {
        if likedNFTs.contains(nftId) {
            likedNFTs.remove(nftId)
        } else {
            likedNFTs.insert(nftId)
        }
        saveData()
        view?.reloadData()
    }
    
    func loadNFTs() {
        let ids = collection.nfts
        guard !ids.isEmpty else {
            return
        }
        
        view?.showLoading()
        
        let group = DispatchGroup()
        var loadedNfts: [Nft] = []
        var fetchError: Error?
        
        ids.forEach { id in
            group.enter()
            service.fetchNFT(id: id) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let nft):
                    loadedNfts.append(nft)
                case .failure(let error):
                    fetchError = error
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            view?.hideLoading()
            
            if let error = fetchError {
                let errorModel = ErrorModel(
                    message: "Не удалось загрузить часть данных",
                    actionText: "Повторить",
                    action: { [weak self] in self?.loadNFTs() }
                )
                view?.showError(errorModel)
            } else {
                nfts = loadedNfts
                view?.reloadData()
            }
        }
    }
    
    func isInCart(nftId: String) -> Bool {
        return cartNFTs.contains(nftId)
    }
    
    func toggleCart(nftId: String) {
        view?.showLoading()
        
        cartService.loadCart { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let order):
                var updatedIds = order.nfts
                
                if updatedIds.contains(nftId) {
                    updatedIds.removeAll { $0 == nftId }
                } else {
                    updatedIds.append(nftId)
                }
                
                self.cartService.updateOrder(nftIds: updatedIds) { [weak self] updateResult in
                    DispatchQueue.main.async {
                        self?.view?.hideLoading()
                        switch updateResult {
                        case .success(let newOrder):
                            self?.cartNFTs = Set(newOrder.nfts)
                            self?.saveData()
                            self?.view?.reloadData()
                        case .failure(let error):
                            print("Ошибка обновления корзины: \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                self.handleLoadCartError(error, nftId: nftId)
            }
        }
    }
    
    private func updateServerCart(with ids: [String]) {
        cartService.updateOrder(nftIds: ids) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let order):
                    self?.cartNFTs = Set(order.nfts)
                    self?.saveData()
                    self?.view?.reloadData()
                case .failure(let error):
                    print("Update Error: \(error)")
                }
            }
        }
    }

    private func handleLoadCartError(_ error: Error, nftId: String) {
        if let networkError = error as? NetworkClientError,
           case .httpStatusCode(let code) = networkError, code == 406 {
            updateServerCart(with: [nftId])
        } else {
            DispatchQueue.main.async {
                self.view?.hideLoading()
            }
        }
    }
    
    private func saveData() {
        UserDefaults.standard.set(Array(likedNFTs), forKey: likesKey)
        UserDefaults.standard.set(Array(cartNFTs), forKey: cartKey)
    }
    
    private func loadData() {
        if let likes = UserDefaults.standard.stringArray(forKey: likesKey) {
            likedNFTs = Set(likes)
        }
        if let cart = UserDefaults.standard.stringArray(forKey: cartKey) {
            cartNFTs = Set(cart)
        }
    }
}
