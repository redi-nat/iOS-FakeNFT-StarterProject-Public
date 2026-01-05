import UIKit

final class CollectionDetailAssembly {
    static func assembly(with collection: CollectionModel) -> UIViewController {
        let view = CollectionDetailViewController()
        
        let service = CatalogService()
        
        let presenter = CollectionDetailPresenter(
            view: view,
            collection: collection,
            service: service
        )
        
        view.presenter = presenter
        return view
    }
}
