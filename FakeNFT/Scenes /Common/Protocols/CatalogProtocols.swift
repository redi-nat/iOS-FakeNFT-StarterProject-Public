import Foundation

protocol CatalogViewProtocol: AnyObject {
    func reloadTableView()
    func showLoading()
    func hideLoading()
}

protocol CatalogPresenterProtocol {
    var collections: [CollectionModel] { get }
    func viewDidLoad()
    func didSelectCollection(at indexPath: IndexPath)
    func sortByName()
    func sortByCount()
}
