import UIKit
import Kingfisher

/// Ячейка для отображения NFT в корзине
final class CartNFTTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - UI Elements
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .tabBarInactive
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Cart.price", comment: "")
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .tabBarInactive
        return label
    }()
    
    private lazy var priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .tabBarInactive
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        let deleteImage = UIImage(named: "deleteFromCart")?.withRenderingMode(.alwaysTemplate)
        button.setImage(deleteImage, for: .normal)
        button.tintColor = .tabBarInactive
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var onDelete: (() -> Void)?
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        // Основной контейнер (343x108)
        let mainContainer = UIView()
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainContainer)
        
        // Левая часть с изображением и информацией (204x108)
        let leftContainer = UIView()
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Контейнер для информации (76x92)
        let infoContainer = UIView()
        infoContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Контейнер для названия и рейтинга (68x38)
        let nameRatingContainer = UIView()
        nameRatingContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Контейнер для цены (76x42)
        let priceContainer = UIView()
        priceContainer.translatesAutoresizingMaskIntoConstraints = false
        
        // Настраиваем translatesAutoresizingMaskIntoConstraints
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingStackView.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceValueLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем элементы
        leftContainer.addSubview(nftImageView)
        leftContainer.addSubview(infoContainer)
        
        nameRatingContainer.addSubview(nameLabel)
        nameRatingContainer.addSubview(ratingStackView)
        
        priceContainer.addSubview(priceLabel)
        priceContainer.addSubview(priceValueLabel)
        
        infoContainer.addSubview(nameRatingContainer)
        infoContainer.addSubview(priceContainer)
        
        mainContainer.addSubview(leftContainer)
        mainContainer.addSubview(deleteButton)
        
        contentView.addSubview(mainContainer)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Main container (343x108)
            mainContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Left container (204x108)
            leftContainer.topAnchor.constraint(equalTo: mainContainer.topAnchor),
            leftContainer.leadingAnchor.constraint(equalTo: mainContainer.leadingAnchor),
            leftContainer.bottomAnchor.constraint(equalTo: mainContainer.bottomAnchor),
            leftContainer.widthAnchor.constraint(equalToConstant: 204),
            
            // NFT Image (108x108)
            nftImageView.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: leftContainer.leadingAnchor),
            nftImageView.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            // Info container (76x92)
            infoContainer.topAnchor.constraint(equalTo: leftContainer.topAnchor),
            infoContainer.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            infoContainer.bottomAnchor.constraint(equalTo: leftContainer.bottomAnchor),
            infoContainer.widthAnchor.constraint(equalToConstant: 76),
            
            // Name rating container (68x38)
            nameRatingContainer.topAnchor.constraint(equalTo: infoContainer.topAnchor),
            nameRatingContainer.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            nameRatingContainer.widthAnchor.constraint(equalToConstant: 68),
            nameRatingContainer.heightAnchor.constraint(equalToConstant: 38),
            
            // Name label
            nameLabel.topAnchor.constraint(equalTo: nameRatingContainer.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: nameRatingContainer.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: nameRatingContainer.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Rating stack view
            ratingStackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingStackView.leadingAnchor.constraint(equalTo: nameRatingContainer.leadingAnchor),
            ratingStackView.trailingAnchor.constraint(equalTo: nameRatingContainer.trailingAnchor),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            
            // Price container (76x42)
            priceContainer.topAnchor.constraint(equalTo: nameRatingContainer.bottomAnchor, constant: 12),
            priceContainer.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor),
            priceContainer.widthAnchor.constraint(equalToConstant: 76),
            priceContainer.heightAnchor.constraint(equalToConstant: 42),
            
            // Price label
            priceLabel.topAnchor.constraint(equalTo: priceContainer.topAnchor),
            priceLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor),
            priceLabel.heightAnchor.constraint(equalToConstant: 18),
            
            // Price value label
            priceValueLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            priceValueLabel.leadingAnchor.constraint(equalTo: priceContainer.leadingAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: priceContainer.trailingAnchor),
            priceValueLabel.heightAnchor.constraint(equalToConstant: 22),
            
            // Delete button (40x40)
            deleteButton.centerYAnchor.constraint(equalTo: mainContainer.centerYAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: mainContainer.trailingAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        // Настраиваем звезды для рейтинга
        setupRatingStars()
    }
    
    private func setupRatingStars() {
        // Создаем 5 звезд размером 12x11.25 согласно макету
        for _ in 0..<5 {
            let starImageView = UIImageView()
            starImageView.contentMode = .scaleAspectFit
            starImageView.translatesAutoresizingMaskIntoConstraints = false
            starImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starImageView.heightAnchor.constraint(equalToConstant: 11.25).isActive = true
            ratingStackView.addArrangedSubview(starImageView)
        }
    }
    
    // MARK: - Configuration
    
    func configure(with model: CartNFTCellModel) {
        // Загружаем изображение
        if let imageURL = model.imageURL {
            nftImageView.kf.setImage(with: imageURL)
        } else {
            // Используем изображение из Assets как заглушку
            nftImageView.image = UIImage(named: "April")
        }
        
        // Название
        nameLabel.text = model.name
        
        // Рейтинг (обновляем звезды)
        updateRating(rating: model.rating)
        
        // Цена (формат: 1,78 ETH с запятой)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = ","
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        if let formattedPrice = formatter.string(from: NSNumber(value: model.price)) {
            priceValueLabel.text = "\(formattedPrice) ETH"
        } else {
            priceValueLabel.text = String(format: "%.2f ETH", model.price)
        }
    }
    
    private func updateRating(rating: Int) {
        let starViews = ratingStackView.arrangedSubviews.compactMap { $0 as? UIImageView }
        
        for (index, starView) in starViews.enumerated() {
            if index < rating {
                // Активная звезда - желтая заливка #FEEF0D
                starView.image = UIImage(systemName: "star.fill")
                starView.tintColor = .starActive
            } else {
                // Неактивная звезда - серая заливка #F7F7F8 без обводки
                starView.image = UIImage(systemName: "star.fill")
                starView.tintColor = .starInactive
            }
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func deleteButtonTapped() {
        onDelete?()
    }
}

