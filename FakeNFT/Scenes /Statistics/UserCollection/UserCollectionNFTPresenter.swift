import Foundation

protocol UserNFTCollectionViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayNFTs(_ nfts: [UserNFT])
    func updateLikes(_ likes: [String])
    func showError(_ model: ErrorModel)
}

protocol UserNFTCollectionPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLikeButton(for nftId: String)
    func didTapCartButton(for nftId: String)
}

final class UserNFTCollectionPresenter: UserNFTCollectionPresenterProtocol {
    weak var view: UserNFTCollectionViewProtocol?
    
    private let nftIds: [String]
    private let networkClient: NetworkClient
    private let likesService: LikesService
    private var nfts: [UserNFT] = []
    private var likes: [String] = []
    private var cartItems: [String] = []
    
    init(nftIds: [String], networkClient: NetworkClient, likesService: LikesService) {
        self.nftIds = nftIds
        self.networkClient = networkClient
        self.likesService = likesService
    }
    
    func viewDidLoad() {
        loadNFTs()
        loadLikes()
    }
    
    private func loadNFTs() {
        guard !nftIds.isEmpty else {
            view?.displayNFTs([])
            return
        }
        
        view?.showLoading()
        
        var loadedNFTs: [UserNFT] = []
        let group = DispatchGroup()
        var errors: [String: Error] = [:]
        
        for nftId in nftIds {
            group.enter()
            
            let request = UserNFTRequest(id: nftId)
            
            networkClient.send(request: request, type: UserNFT.self) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let nft):
                        loadedNFTs.append(nft)
                        AppLogger.info("✅ Загружен NFT: \(nft.name)", category: .statistic)
                    case .failure(let error):
                        errors[nftId] = error
                        AppLogger.error("❌ Ошибка загрузки NFT \(nftId): \(error)", category: .statistic)
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            self.view?.hideLoading()
            self.nfts = loadedNFTs
            
            if !loadedNFTs.isEmpty {
                self.view?.displayNFTs(loadedNFTs)
                
                if !errors.isEmpty {
                    let errorModel = ErrorModel(
                        message: "Загружено \(loadedNFTs.count) из \(self.nftIds.count) NFT",
                        actionText: "Понятно",
                        action: {}
                    )
                    self.view?.showError(errorModel)
                }
            } else {
                let errorModel = ErrorModel(
                    message: "Не удалось загрузить коллекцию NFT",
                    actionText: "Повторить",
                    action: { [weak self] in
                        self?.loadNFTs()
                    }
                )
                self.view?.showError(errorModel)
            }
        }
    }
    
    private func loadLikes() {
        likesService.loadLikes { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let likes):
                    self?.likes = likes
                    self?.view?.updateLikes(likes)
                case .failure(let error):
                    AppLogger.error("Ошибка загрузки лайков: \(error)", category: .statistic)
                }
            }
        }
    }
    
    func didTapLikeButton(for nftId: String) {
        if likes.contains(nftId) {
            likes.removeAll { $0 == nftId }
        } else {
            likes.append(nftId)
        }
        view?.updateLikes(likes)
        
        likesService.updateLikes(likes) { result in
            switch result {
            case .success:
                AppLogger.info("✅ Лайки обновлены на сервере", category: .statistic)
            case .failure(let error):
                AppLogger.error("❌ Ошибка обновления лайков: \(error)", category: .statistic)
            }
        }
    }
    
    func didTapCartButton(for nftId: String) {
        if cartItems.contains(nftId) {
            cartItems.removeAll { $0 == nftId }
        } else {
            cartItems.append(nftId)
        }
    }
}
