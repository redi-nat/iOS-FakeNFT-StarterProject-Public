import Foundation

/// Assembly для создания экрана выбора валюты
final class CurrencySelectionAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func build(orderId: String, purchasedNFTIds: [String]) -> CurrencySelectionViewController {
        let presenter = CurrencySelectionPresenterImpl(
            currencyService: servicesAssembly.currencyService,
            paymentService: servicesAssembly.paymentService,
            cartService: servicesAssembly.cartService,
            profileService: servicesAssembly.profileService,
            orderId: orderId,
            purchasedNFTIds: purchasedNFTIds
        )
        
        let viewController = CurrencySelectionViewController(
            presenter: presenter,
            cartService: servicesAssembly.cartService
        )
        presenter.view = viewController
        
        return viewController
    }
}

