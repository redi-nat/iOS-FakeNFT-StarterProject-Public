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
            case .success(let data):
                self.collections = data
                
                let savedRawValue = UserDefaults.standard.string(forKey: "CatalogSortOrder") ?? ""
                
                if let savedSortType = SortType(rawValue: savedRawValue) {
                    self.applySort(type: savedSortType)
                } else {
                    self.view?.reloadTableView()
                }
                
            case .failure:
                break
            }
        }
    }
    
    func didSelectCollection(at indexPath: IndexPath) {
        let selectedCollection = collections[indexPath.row]
        router.openCollectionDetail(collection: selectedCollection)
    }
    
    func sortByName() {
        applySort(type: .name)
    }

    func sortByCount() {
        applySort(type: .count)
    }
    
    private func applySort(type: SortType) {
        switch type {
        case .name:
            collections.sort { $0.name < $1.name }
        case .count:
            collections.sort { $0.nfts.count > $1.nfts.count }
        }
        
        UserDefaults.standard.set(type.rawValue, forKey: "CatalogSortOrder")
        view?.reloadTableView()
    }
}

enum SortType: String {
    case name
    case count
}
