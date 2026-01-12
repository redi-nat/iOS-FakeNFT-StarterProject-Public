import UIKit
import Kingfisher

final class CollectionDetailViewController: UIViewController, CollectionDetailViewProtocol {

    var presenter: CollectionDetailPresenterProtocol?
    
    private let headerView = CollectionDetailHeaderView()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.contentInsetAdjustmentBehavior = .never
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        collectionView.register(NFTCollectionCell.self, forCellWithReuseIdentifier: "NFTCollectionCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: -450),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 450)
        ])
        
        collectionView.contentInset = UIEdgeInsets(top: 450, left: 0, bottom: 0, right: 0)
    }
    
    func displayCollectionInfo() {
        guard let collection = presenter?.getCollection() else { return }
        headerView.configure(with: collection)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }

    func showError(_ model: ErrorModel) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: model.message,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(
                title: model.actionText,
                style: .default,
                handler: { _ in model.action() }
            ))
            
            self.present(alert, animated: true)
        }
    }

}

// MARK: - UICollectionViewDataSource
extension CollectionDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTCollectionCell", for: indexPath) as? NFTCollectionCell,
              let nft = presenter?.nft(at: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        let isLiked = presenter?.isLiked(nftId: nft.id) ?? false
        let isInCart = presenter?.isInCart(nftId: nft.id) ?? false
        
        cell.configure(with: nft, isLiked: isLiked, isInCart: isInCart)
        
        cell.onLikeButtonTapped = { [weak self] in
            self?.presenter?.toggleLike(nftId: nft.id)
        }
        
        cell.onCartButtonTapped = { [weak self] in
            self?.presenter?.toggleCart(nftId: nft.id)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 32 - 18) / 3
        return CGSize(width: width, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
}
