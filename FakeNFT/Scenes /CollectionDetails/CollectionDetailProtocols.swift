import Foundation

protocol CollectionDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getCollection() -> CollectionModel
    func numberOfItems() -> Int
    func nft(at index: Int) -> Nft?
    func isLiked(nftId: String) -> Bool
    func isInCart(nftId: String) -> Bool
    func toggleLike(nftId: String)
    func toggleCart(nftId: String)
}

protocol CollectionDetailViewProtocol: AnyObject {
    func displayCollectionInfo()
    func reloadData()
    
    func showLoading()
    func hideLoading()
    func showError(_ model: ErrorModel)
}

