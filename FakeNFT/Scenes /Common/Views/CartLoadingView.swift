import UIKit

/// Кастомный view для отображения индикатора загрузки согласно дизайну
final class CartLoadingView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F7F7F8")
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .label
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            // Container: 82x82, padding 26px
            containerView.widthAnchor.constraint(equalToConstant: 82),
            containerView.heightAnchor.constraint(equalToConstant: 82),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            // ActivityIndicator: увеличенный размер для лучшей видимости, centered in container
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    
    func startAnimating() {
        activityIndicator.startAnimating()
        isHidden = false
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        isHidden = true
    }
}


