import UIKit

final class UserNFTCollectionVC: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 9
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UserNFTCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .label
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let refreshControl = UIRefreshControl()
    private var presenter: UserNFTCollectionPresenterProtocol
    private var nfts: [UserNFT] = []
    private var likes: [String] = []
    
    init(presenter: UserNFTCollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
        
        hidesBottomBarWhenPushed = true
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Коллекция NFT"
        setupNavigationBar()
        setupConstraints()
        setupRefreshControl()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
    }
    
    private func setupConstraints() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = .label
        collectionView.refreshControl = refreshControl
        refreshControl.addAction( UIAction { [weak self] _ in
            self?.presenter.viewDidLoad()
        }, for: .valueChanged)
    }
}

// MARK: - UICollectionViewDataSource
extension UserNFTCollectionVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UserNFTCollectionCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        
        let nft = nfts[indexPath.item]
        let isLiked = likes.contains(nft.id)
        
        let isInCart = false
        
        cell.configure(with: nft, isLiked: isLiked, isInCart: isInCart)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension UserNFTCollectionVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: 108, height: 192)
        }
        
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let insets = flowLayout.sectionInset
        
        let totalSpacing = insets.left + insets.right + (spacing * 2)
        let width = (collectionView.frame.width - totalSpacing) / 3
        
        return CGSize(width: width, height: width * 1.8)
    }
}

// MARK: - NFTCollectionCellDelegate
extension UserNFTCollectionVC: NFTCollectionCellDelegate {
    func didTapLikeButton(in cell: UserNFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        presenter.didTapLikeButton(for: nft.id)
    }
    
    func didTapCartButton(in cell: UserNFTCollectionCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        let nft = nfts[indexPath.item]
        presenter.didTapCartButton(for: nft.id)
    }
}

// MARK: - NFTCollectionViewProtocol
extension UserNFTCollectionVC: UserNFTCollectionViewProtocol {
    func displayNFTs(_ nfts: [UserNFT]) {
        self.nfts = nfts
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func updateLikes(_ likes: [String]) {
        self.likes = likes
        collectionView.reloadData()
    }
    
    func showLoading() {
        if !refreshControl.isRefreshing {
            activityIndicator.startAnimating()
        }
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
        refreshControl.endRefreshing()
    }
}

extension UserNFTCollectionVC: ErrorView {
    
}
