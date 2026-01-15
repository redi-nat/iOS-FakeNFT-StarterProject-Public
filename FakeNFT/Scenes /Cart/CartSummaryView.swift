import UIKit

/// Нижняя панель с итогами корзины
final class CartSummaryView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "F7F7F8")
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Только верхние углы
        return view
    }()
    
    private lazy var contentContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var infoContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var countContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .tabBarInactive
        label.text = "0 NFT"
        return label
    }()
    
    private lazy var totalLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor(hexString: "1C9F00") // Зеленый цвет
        label.text = "0 ETH"
        return label
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .tabBarInactive
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("Cart.pay", comment: ""), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var onPay: (() -> Void)?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(containerView)
        containerView.addSubview(contentContainer)
        contentContainer.addSubview(infoContainer)
        contentContainer.addSubview(payButton)
        
        infoContainer.addSubview(countContainer)
        infoContainer.addSubview(totalLabel)
        
        countContainer.addSubview(countLabel)
        
        [containerView, contentContainer, infoContainer, countContainer, countLabel, totalLabel, payButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // Container view (375x76)
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 76),
            
            // Content container (padding 16px)
            contentContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            contentContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            contentContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            contentContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            // Info container (79x44)
            infoContainer.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            infoContainer.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            infoContainer.widthAnchor.constraint(equalToConstant: 79),
            infoContainer.heightAnchor.constraint(equalToConstant: 44),
            
            // Count container (42x20)
            countContainer.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            countContainer.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            countContainer.widthAnchor.constraint(equalToConstant: 42),
            countContainer.heightAnchor.constraint(equalToConstant: 20),
            
            // Count label
            countLabel.topAnchor.constraint(equalTo: countContainer.topAnchor),
            countLabel.leadingAnchor.constraint(equalTo: countContainer.leadingAnchor),
            countLabel.trailingAnchor.constraint(equalTo: countContainer.trailingAnchor),
            countLabel.heightAnchor.constraint(equalToConstant: 20),
            
            // Total label (79x22)
            totalLabel.topAnchor.constraint(equalTo: countContainer.bottomAnchor, constant: 2),
            totalLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            totalLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor),
            totalLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Pay button (240x44)
            payButton.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            payButton.centerYAnchor.constraint(equalTo: contentContainer.centerYAnchor),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Public Methods
    
    func update(count: Int, total: Double) {
        // Обновляем количество NFT
        countLabel.text = "\(count) NFT"
        
        // Обновляем общую сумму (формат: 5,34 ETH с запятой)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedTotal = formatter.string(from: NSNumber(value: total)) {
            totalLabel.text = "\(formattedTotal) ETH"
        } else {
            totalLabel.text = String(format: "%.2f ETH", total)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func payButtonTapped() {
        onPay?()
    }
}

