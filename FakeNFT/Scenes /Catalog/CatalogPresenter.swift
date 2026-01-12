import Foundation

final class CatalogPresenter: CatalogPresenterProtocol {
    private weak var view: CatalogViewProtocol?
    private let service: CatalogServiceProtocol
    private let router: CatalogRouterProtocol
    
    private(set) var collections: [CollectionModel] = []
    
    init(view: CatalogViewProtocol, service: CatalogServiceProtocol, router: CatalogRouterProtocol) {
        self.view = view
        self.service = service
        self.router = router
    }
    
    func viewDidLoad() {
        view?.showLoading()
        service.loadCollections { [weak self] result in
            guard let self = self else { return }
            self.view?.hideLoading()
            
            switch result {
            case .success(let collections):
                self.collections = collections
                self.view?.reloadTableView()
            case .failure(let error):
                print("Error loading: \(error)")
            }
        }
    }
    
    func didSelectCollection(at indexPath: IndexPath) {
        let selectedCollection = collections[indexPath.row]
        router.openCollectionDetail(collection: selectedCollection)
    }
}
