import Foundation

/// Assembly для создания экрана выбора валюты
final class CurrencySelectionAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func build(orderId: String) -> CurrencySelectionViewController {
        let presenter = CurrencySelectionPresenterImpl(
            currencyService: servicesAssembly.currencyService,
            paymentService: servicesAssembly.paymentService,
            orderId: orderId
        )
        
        let viewController = CurrencySelectionViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}

