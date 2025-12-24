import Foundation

// MARK: - Protocol

protocol CartPresenter {
    func viewDidLoad()
    func deleteNFT(id: String)
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
        state = .loading
    }
    
    func deleteNFT(id: String) {
        view?.showLoading()
        cartService.removeNFT(id: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let order):
                    if order.nfts.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .data(order.nfts)
                    }
                case .failure(let error):
                    self?.state = .failed(error)
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
            // Скрываем loading перед обновлением данных
            view?.hideLoading()
            let count = nfts.count
            let total = nfts.reduce(0.0) { $0 + $1.price }
            view?.displayNFTs(nfts)
            view?.updateSummary(count: count, total: total)
        case .empty:
            // Скрываем loading перед обновлением данных
            view?.hideLoading()
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
                    if order.nfts.isEmpty {
                        self?.state = .empty
                    } else {
                        self?.state = .data(order.nfts)
                    }
                case .failure(let error):
                    self?.state = .failed(error)
                }
            }
        }
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

