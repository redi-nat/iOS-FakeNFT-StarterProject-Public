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
        
        viewController.hidesBottomBarWhenPushed = true
        
        presenter.view = viewController
        
        viewController.onWebsiteTap = { url in
            let webViewController = UserWebsiteVC(url: url)
            navigationController?.pushViewController(webViewController, animated: true)
        }
        
        viewController.onCollectionTap = { [weak navigationController] user in
        
            let collectionAssembly = UserNFTCollectionAssembly(
                servicesAssembly: self.servicesAssembly
                        )
        let collectionVC = collectionAssembly.assemble(nftIds: user.nfts)
        navigationController?.pushViewController(collectionVC, animated: true)
    }
    return viewController
}
}
