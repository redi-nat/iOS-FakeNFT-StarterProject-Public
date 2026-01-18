import UIKit

/// Сборка компонентов для экрана корзины (Dependency Injection)
final class CartAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func build() -> UIViewController {
        let presenter = CartPresenterImpl(
            cartService: servicesAssembly.cartService
        )
        let viewController = CartViewController(presenter: presenter, servicesAssembly: servicesAssembly)
        presenter.view = viewController
        return viewController
    }
}

