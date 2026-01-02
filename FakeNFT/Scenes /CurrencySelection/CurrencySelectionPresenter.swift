import Foundation

// MARK: - Protocol

protocol CurrencySelectionPresenter {
    func viewDidLoad()
    func selectCurrency(at index: Int)
    func payButtonTapped()
}

// MARK: - State

enum CurrencySelectionState {
    case initial
    case loading
    case data([Currency])
    case failed(Error)
}

// MARK: - Implementation

final class CurrencySelectionPresenterImpl: CurrencySelectionPresenter {
    
    // MARK: - Properties
    
    weak var view: CurrencySelectionView?
    private let currencyService: CurrencyService
    private let paymentService: PaymentService
    private let orderId: String
    private var currencies: [Currency] = []
    private var selectedCurrencyIndex: Int?
    private var state = CurrencySelectionState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    
    init(
        currencyService: CurrencyService,
        paymentService: PaymentService,
        orderId: String
    ) {
        self.currencyService = currencyService
        self.paymentService = paymentService
        self.orderId = orderId
    }
    
    // MARK: - Functions
    
    func viewDidLoad() {
        state = .loading
    }
    
    func selectCurrency(at index: Int) {
        guard index >= 0 && index < currencies.count else { return }
        selectedCurrencyIndex = index
        view?.updatePayButton(enabled: true)
    }
    
    func payButtonTapped() {
        guard let index = selectedCurrencyIndex,
              index >= 0 && index < currencies.count else {
            // Если валюта не выбрана, показываем ошибку
            let errorModel = makeNoCurrencySelectedErrorModel()
            view?.showError(errorModel)
            return
        }
        
        let selectedCurrency = currencies[index]
        view?.showLoading()
        
        paymentService.payOrder(orderId: orderId, currencyId: selectedCurrency.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let paymentResponse):
                    self.view?.hideLoading()
                    // Переход на экран подтверждения оплаты
                    self.view?.showPaymentSuccess()
                case .failure(let error):
                    self.view?.hideLoading()
                    let errorModel = self.makePaymentErrorModel(error)
                    self.view?.showError(errorModel)
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
            loadCurrencies()
        case .data(let currencies):
            self.currencies = currencies
            view?.hideLoading()
            view?.displayCurrencies(currencies)
            view?.updatePayButton(enabled: false)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        }
    }
    
    private func loadCurrencies() {
        currencyService.loadCurrencies { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self?.state = .data(currencies)
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
    
    private func makeNoCurrencySelectedErrorModel() -> ErrorModel {
        let message = NSLocalizedString("Payment.Error.NoCurrency", comment: "Не удалось провести оплату")
        let repeatActionText = NSLocalizedString("Payment.Error.Repeat", comment: "Повторить")
        let cancelActionText = NSLocalizedString("Payment.Error.Cancel", comment: "Отмена")
        
        // Создаем модель ошибки с двумя действиями: повторить (жирный) и отмена
        return ErrorModel(
            message: message,
            actionText: repeatActionText,
            action: {
                // При повторить ничего не делаем, просто закрываем
            },
            cancelText: cancelActionText,
            cancelAction: {
                // При отмене ничего не делаем, просто закрываем алерт
            }
        )
    }
    
    private func makePaymentErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Payment.Error.Network", comment: "Не удалось провести оплату")
        default:
            message = NSLocalizedString("Payment.Error.Unknown", comment: "Не удалось провести оплату")
        }
        
        let repeatActionText = NSLocalizedString("Payment.Error.Repeat", comment: "Повторить")
        let cancelActionText = NSLocalizedString("Payment.Error.Cancel", comment: "Отмена")
        
        // Создаем модель ошибки с двумя действиями: повторить (жирный) и отмена
        return ErrorModel(
            message: message,
            actionText: repeatActionText,
            action: { [weak self] in
                self?.payButtonTapped()
            },
            cancelText: cancelActionText,
            cancelAction: {
                // При отмене ничего не делаем, просто закрываем алерт
            }
        )
    }
}

