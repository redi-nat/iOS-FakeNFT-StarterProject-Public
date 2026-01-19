import UIKit

final class UserNFTCollectionAssembly {
    private let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
            self.servicesAssembly = servicesAssembly
        }
    
    func assemble(nftIds: [String]) -> UserNFTCollectionVC {
        let presenter = UserNFTCollectionPresenter(
            nftIds: nftIds,
            networkClient: servicesAssembly.networkClient,
            likesService: servicesAssembly.likesService
        )
        
        let viewController = UserNFTCollectionVC(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
