import Foundation

// MARK: - Protocol

protocol CartPresenter {
    func viewDidLoad()
    func deleteNFT(id: String)
    func changeSortOption(_ option: CartSortOption)
    func getOrderId() -> String
    func reloadCart()
    func getCurrentNFTs() -> [CartNFT]
}

// MARK: - State

enum CartState {
    case initial
    case loading
    case data([CartNFT])
    case empty
    case failed(Error)
}

// MARK: - Implementation

final class CartPresenterImpl: CartPresenter {
    
    // MARK: - Properties
    
    weak var view: CartView?
    private let cartService: CartService
    private var currentNFTs: [CartNFT] = []
    private var currentOrderId: String = "1" // По умолчанию "1", можно получить из заказа
    private var sortOption: CartSortOption = CartSortUtility.loadSortOption()
    private var state = CartState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    
    init(cartService: CartService) {
        self.cartService = cartService
    }
    
    // MARK: - Functions
    
    func viewDidLoad() {
        // Загружаем сохраненную сортировку
        sortOption = CartSortUtility.loadSortOption()
        state = .loading
    }
    
    func changeSortOption(_ option: CartSortOption) {
        sortOption = option
        CartSortUtility.saveSortOption(option)
        // Применяем сортировку к текущим данным
        applySorting()
    }
    
    func getOrderId() -> String {
        return currentOrderId
    }
    
    func reloadCart() {
        state = .loading
    }
    
    func getCurrentNFTs() -> [CartNFT] {
        return currentNFTs
    }
    
    func deleteNFT(id: String) {
        view?.showLoading()
        
        var newIds = currentNFTs.map { $0.id }
        newIds.removeAll { $0 == id }
        
        cartService.updateOrder(nftIds: newIds) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    if order.nfts.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.fetchNFTDetails(ids: order.nfts)
                    }
                    
                case .failure(let error):
                    if let networkError = error as? NetworkClientError,
                       case .httpStatusCode(let code) = networkError, code == 406 {
                        if newIds.isEmpty {
                            self?.currentNFTs = []
                            self?.state = .empty
                        } else {
                            self?.state = .failed(error)
                        }
                    } else {
                        self?.state = .failed(error)
                    }
                }
            }
        }
    }
    
    // MARK: - Private
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoading()
            loadCart()
        case .data(let nfts):
            // Сохраняем текущие NFT
            currentNFTs = nfts
            // Применяем сортировку
            applySorting()
        case .empty:
            // Скрываем loading перед обновлением данных
            view?.hideLoading()
            currentNFTs = []
            view?.displayNFTs([])
            view?.updateSummary(count: 0, total: 0)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadCart() {
        cartService.loadCart { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    self?.fetchNFTDetails(ids: order.nfts)
                    
                case .failure(let error):
                    if let networkError = error as? NetworkClientError,
                       case .httpStatusCode(let code) = networkError, code == 406 {
                        self?.state = .empty
                    } else {
                        self?.state = .failed(error)
                    }
                    
                }
            }
        }
    }
    
    private func fetchNFTDetails(ids: [String]) {
        let group = DispatchGroup()
        var loadedNFTs: [CartNFT] = []
        
        for id in ids {
            group.enter()
            cartService.loadNFT(id: id) { result in
                if case .success(let nft) = result {
                    loadedNFTs.append(nft)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.state = .data(loadedNFTs)
        }
    }
    
    private func applySorting() {
        let sortedNFTs = CartSortUtility.sort(currentNFTs, by: sortOption)
        // Скрываем loading перед обновлением данных
        view?.hideLoading()
        let count = sortedNFTs.count
        let total = sortedNFTs.reduce(0.0) { $0 + $1.price }
        view?.displayNFTs(sortedNFTs)
        view?.updateSummary(count: count, total: total)
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
}

