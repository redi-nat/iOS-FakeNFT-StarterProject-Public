import UIKit

final class UserCardAssembly {
    
    private let servicesAssembly: ServicesAssembly
    
    init (servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    func assemble(userId: String, navigationController: UINavigationController?) -> UserCardVC {
        let usersService = servicesAssembly.usersService
        let presenter = UserCardPresenter(usersService: usersService)
        let viewController = UserCardVC(presenter: presenter, userId: userId)
        
        presenter.view = viewController
        
        viewController.onWebsiteTap = { url in
            let webViewController = UserWebsiteVC(url: url)
            navigationController?.pushViewController(webViewController, animated: true)
        }
        
        viewController.onCollectionTap = { user in
            // Здесь будет переход к коллекции NFT пользователя
            print("Переход к коллекции пользователя: \(user.name)")
        }
        return viewController
    }
}
