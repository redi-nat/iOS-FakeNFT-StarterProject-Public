import UIKit
import Kingfisher

protocol UserCardViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func displayUserData(_ user: User)
    func showError(_ message: String)
}

final class UserCardVC: UIViewController {
    
    // Mark: – UI Components
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in self?.toUserWebsiteGo() }, for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Коллекция NFT (112)", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(.label, for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in self?.toUserCollectonNFTGo() },
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .label
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .label
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    //  Mark:  – Properties
    private var presenter: UserCardPresenterProtocol
    private var userId: String
    var onWebsiteTap: ((URL) -> Void)?
    var onCollectionTap: ((User) -> Void)?
    
    // Mark: – Initializer
    
    init(presenter: UserCardPresenterProtocol, userId: String) {
        self.presenter = presenter
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Mark: – Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad(with: userId)
        
        presenter.onWebsiteTap = { [weak self] url in
            self?.onWebsiteTap?(url)
        }
        
        presenter.onCollectionTap = { [weak self] user in
            self?.onCollectionTap?(user)
        }
    }
    
    // Mark: – Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = ""
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .label
        navigationItem.backButtonTitle = ""
    }
    
    private func setupConstraints() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(websiteButton)
        view.addSubview(collectionButton)
        view.addSubview(arrowImageView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            websiteButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 28),
            websiteButton.heightAnchor.constraint(equalToConstant: 40),
            websiteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            websiteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionButton.topAnchor.constraint(equalTo: websiteButton.bottomAnchor, constant: 41),
            collectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 54),
            
            arrowImageView.centerYAnchor.constraint(equalTo: collectionButton.centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: websiteButton.trailingAnchor),
            arrowImageView.heightAnchor.constraint(equalToConstant: 13.86),
            
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // Mark: – Actions
    private func toUserWebsiteGo() {
        presenter.toUserWebsiteGo()
    }
    
    private func toUserCollectonNFTGo() {
        presenter.toUserCollectonNFTGo()
    }
    
    // Mark: – Private Methods
    private func updateCollectionButtonTitle(count: Int) {
        let title = "Коллекция NFT (\(count))"
        collectionButton.setTitle(title, for: .normal)
    }
}

// Mark: – UserCardViewProtocol
extension UserCardVC: UserCardViewProtocol {
    func displayUserData(_ user: User) {
        nameLabel.text = user.name
        descriptionTextView.text = user.description ?? "No description"
        
        if let url = URL(string: user.avatar) {
            
            let placeholder = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .universalGrey), renderingMode: .alwaysOriginal)
            
            avatarImageView.kf.setImage(
                with: url,
                placeholder: placeholder,
                options: [.transition(.fade(0.2))]
            )
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(UIColor(resource: .universalGrey), renderingMode: .alwaysOriginal)
        }
        updateCollectionButtonTitle(count: user.nfts.count)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(
            title: "",
            message: "Не удалось получить данные",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) {[weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        let retryAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            if let userId = self?.userId {
                self?.presenter.viewDidLoad(with: userId)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        
        present(alert, animated: true)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    func hideLoading() {
        activityIndicator.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}
