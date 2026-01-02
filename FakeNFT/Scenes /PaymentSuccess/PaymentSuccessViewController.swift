import UIKit

/// Экран успешной оплаты
final class PaymentSuccessViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private lazy var successImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        // Используем изображение из ассетов successPayment
        imageView.image = UIImage(named: "successPayment")
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        let text = NSLocalizedString("Payment.Success.Message", comment: "Успех! Оплата прошла, поздравляем с покупкой!")
        
        // Настраиваем атрибутированный текст согласно макету
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 28 // line-height: 28px
        paragraphStyle.maximumLineHeight = 28 // line-height: 28px
        
        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor(hexString: "#1A1B22") ?? .label,
                .kern: 0.35, // letter-spacing: 0.35px
                .paragraphStyle: paragraphStyle
            ]
        )
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var returnToCartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(NSLocalizedString("Payment.Success.ReturnToCart", comment: "Вернуться в корзину"), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexString: "#1A1B22")
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(returnToCartTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(successImageView)
        view.addSubview(successLabel)
        view.addSubview(returnToCartButton)
        
        NSLayoutConstraint.activate([
            // Success image - width: 278, height: 278, top: 196px, left: 49px
            successImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 196),
            successImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 49),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            
            // Success label - width: 303, height: 56 (минимум), top: 494px, left: 36px
            successLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 494),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            successLabel.widthAnchor.constraint(equalToConstant: 303),
            successLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            
            // Return to cart button - width: 343, height: 60, top: 702px, left: 16px
            returnToCartButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 702),
            returnToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            returnToCartButton.widthAnchor.constraint(equalToConstant: 343),
            returnToCartButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func returnToCartTapped() {
        // Закрываем все модальные экраны и возвращаемся в корзину
        if let tabBarController = presentingViewController?.presentingViewController as? UITabBarController {
            tabBarController.dismiss(animated: true) {
                tabBarController.selectedIndex = 2 // Индекс вкладки корзины
            }
        } else {
            dismiss(animated: true)
        }
    }
}

