import UIKit

final class CatalogAssembly {
    static func assemble() -> UIViewController {
        let service = CatalogService()
        let view = CatalogViewController()
        let presenter = CatalogPresenter(view: view, service: service)
        
        view.presenter = presenter 
        
        return view
    }
}
