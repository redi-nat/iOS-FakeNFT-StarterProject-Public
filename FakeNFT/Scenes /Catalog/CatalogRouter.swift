import UIKit

protocol CatalogRouterProtocol {
    func openCollectionDetail(collection: CollectionModel)
}

final class CatalogRouter: CatalogRouterProtocol {
    weak var viewController: UIViewController?

    func openCollectionDetail(collection: CollectionModel) {
        let detailVC = CollectionDetailAssembly.assembly(with: collection)
        detailVC.hidesBottomBarWhenPushed = true
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
