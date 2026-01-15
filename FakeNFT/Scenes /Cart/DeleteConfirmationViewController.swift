import UIKit
import Kingfisher

/// Экран подтверждения удаления NFT из корзины
final class DeleteConfirmationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let nftModel: CartNFTCellModel
    private let onConfirm: () -> Void
    private let onCancel: () -> Void
    
    // MARK: - UI Elements
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var confirmationLabel: UILabel = {
        let label = UILabel()
        let text = NSLocalizedString("Cart.Delete.Confirmation", comment: "Вы уверены, что хотите удалить объект из корзины?")
        // Добавляем перенос строки после слова "хотите"
        let formattedText = text.replacingOccurrences(of: "хотите ", with: "хотите\n")
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hexString: "#1A1B22")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        // Устанавливаем line height и letter spacing через attributed string
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = 18
        paragraphStyle.minimumLineHeight = 18
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        label.attributedText = NSAttributedString(
            string: formattedText,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor(hexString: "#1A1B22") ?? .label,
                .kern: -0.08,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("Cart.Delete.Confirm", comment: "Удалить")
        button.backgroundColor = UIColor(hexString: "#1A1B22")
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        
        // Настраиваем атрибутированный текст с правильным шрифтом и letter spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor(hexString: "#FF3B30") ?? .systemRed,
                .kern: -0.41,
                .paragraphStyle: paragraphStyle
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("Cart.Delete.Cancel", comment: "Вернуться")
        button.backgroundColor = UIColor(hexString: "#1A1B22")
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)
        
        // Настраиваем атрибутированный текст с правильным шрифтом и letter spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .regular),
                .foregroundColor: UIColor.white,
                .kern: -0.41,
                .paragraphStyle: paragraphStyle
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(nftModel: CartNFTCellModel, onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) {
        self.nftModel = nftModel
        self.onConfirm = onConfirm
        self.onCancel = onCancel
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithNFT()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.addSubview(backgroundView)
        backgroundView.addSubview(blurEffectView)
        view.addSubview(containerView)
        
        containerView.addSubview(nftImageView)
        containerView.addSubview(confirmationLabel)
        containerView.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(deleteButton)
        buttonsStackView.addArrangedSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            // Background view
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Blur effect view
            blurEffectView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            
            // Container view (262x220, top: 244px, отцентрован по горизонтали)
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 262),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 220), // Минимальная высота, может расширяться
            
            // NFT Image (108x108) - отступ сверху будет рассчитан автоматически через gap
            nftImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            // Confirmation label - gap 20px от картинки
            confirmationLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 20),
            confirmationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            confirmationLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            // Buttons stack view - gap 20px от текста, отцентрованы по горизонтали контейнера
            buttonsStackView.topAnchor.constraint(equalTo: confirmationLabel.bottomAnchor, constant: 20),
            buttonsStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor),
            
            // Delete button (127x44)
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Cancel button (127x44)
            cancelButton.widthAnchor.constraint(equalToConstant: 127),
            cancelButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureWithNFT() {
        // Используем изображение "delete" из ассетов согласно макету Figma
        nftImageView.image = UIImage(named: "delete")
    }
    
    // MARK: - Actions
    
    @objc
    private func deleteButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirm()
        }
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onCancel()
        }
    }
}

