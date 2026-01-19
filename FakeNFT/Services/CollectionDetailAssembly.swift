import UIKit

final class CollectionDetailAssembly {
    static func assembly(with collection: CollectionModel) -> UIViewController {
        let view = CollectionDetailViewController()
        
        let networkClient = DefaultNetworkClient()
        
        let service = CatalogService()
        let cartService = CartServiceImpl(networkClient: networkClient)
        
        let presenter = CollectionDetailPresenter(
            view: view,
            collection: collection,
            service: service,
            cartService: cartService 
        )
        
        view.presenter = presenter
        return view
    }
}
