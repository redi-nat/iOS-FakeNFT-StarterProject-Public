import UIKit

final class CatalogAssembly {
    static func assembly() -> UIViewController {
        let router = CatalogRouter()
        let service = CatalogService()
        let view = CatalogViewController()
        let presenter = CatalogPresenter(view: view, service: service, router: router)
        
        view.presenter = presenter
        router.viewController = view
        
        return view
    }
}
