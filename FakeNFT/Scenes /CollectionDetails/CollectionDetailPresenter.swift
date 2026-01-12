import Foundation

final class CollectionDetailPresenter: CollectionDetailPresenterProtocol {
    
    private weak var view: CollectionDetailViewProtocol?
    private let collection: CollectionModel
    private let service: CatalogService
    private var nfts: [Nft] = []
    
    private let likesKey = "LikedNFTsKey"
    private let cartKey = "CartNFTsKey"
    
    private var cartNFTs: Set<String> = []
    private var likedNFTs: Set<String> = []
    
    init(view: CollectionDetailViewProtocol, collection: CollectionModel, service: CatalogService) {
        self.view = view
        self.collection = collection
        self.service = service
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
        if cartNFTs.contains(nftId) {
            cartNFTs.remove(nftId)
        } else {
            cartNFTs.insert(nftId)
        }
        saveData()
        view?.reloadData()
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
