import UIKit

/// Экран успешной оплаты
final class PaymentSuccessViewController: UIViewController {
    
    // MARK: - Properties
    
    private let cartService: CartService
    
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
    
    init(cartService: CartService) {
        self.cartService = cartService
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
            // Success image - width: 278, height: 278, отцентровано по горизонтали
            successImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 196),
            successImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImageView.widthAnchor.constraint(equalToConstant: 278),
            successImageView.heightAnchor.constraint(equalToConstant: 278),
            
            // Success label - отцентровано по горизонтали
            successLabel.topAnchor.constraint(equalTo: successImageView.bottomAnchor, constant: 20),
            successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -36),
            successLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 303),
            successLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),
            
            // Return to cart button - отцентровано по горизонтали
            returnToCartButton.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 137),
            returnToCartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            returnToCartButton.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            returnToCartButton.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            returnToCartButton.widthAnchor.constraint(equalToConstant: 343),
            returnToCartButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func returnToCartTapped() {
        // Очищаем корзину после успешной оплаты
        cartService.clearCart { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // Находим TabBarController через window
                guard let windowScene = self.view.window?.windowScene,
                      let window = windowScene.windows.first,
                      let tabBarController = window.rootViewController as? UITabBarController else {
                    // Fallback: просто закрываем модальный экран
                    self.dismiss(animated: true)
                    return
                }
                
                // Получаем navigationController корзины (индекс 2)
                guard let cartNavigationController = tabBarController.viewControllers?[2] as? UINavigationController else {
                    self.dismiss(animated: true)
                    return
                }
                
                // Закрываем модальный экран PaymentSuccessViewController
                self.dismiss(animated: true) {
                    // Переключаемся на вкладку корзины в TabBarController
                    tabBarController.selectedIndex = 2
                    
                    // Возвращаемся к корню navigation stack корзины (CartViewController)
                    // Это закроет CurrencySelectionViewController и вернет нас в корзину
                    // viewWillAppear автоматически вызовет reloadCart() и обновит корзину
                    cartNavigationController.popToRootViewController(animated: true)
                }
            }
        }
    }
}

