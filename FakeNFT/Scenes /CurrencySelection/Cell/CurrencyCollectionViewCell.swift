import UIKit
import Kingfisher

/// Ячейка для отображения валюты в коллекции
final class CurrencyCollectionViewCell: UICollectionViewCell, ReuseIdentifying {
    
    // MARK: - UI Elements
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.backgroundColor = UIColor(hexString: "#1A1B22")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hexString: "#1A1B22")
        label.numberOfLines = 1
        label.textAlignment = .left // Выравнивание слева
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(hexString: "#1C9F00")
        label.numberOfLines = 1
        label.textAlignment = .left // Выравнивание слева
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
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
        contentView.backgroundColor = UIColor(hexString: "#F7F7F8")
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true // Обрезаем содержимое по границам
        
        // Создаем контейнер для текстовых меток
        let textStackView = UIStackView()
        textStackView.axis = .vertical
        textStackView.spacing = 0
        textStackView.alignment = .leading // Выравнивание слева
        textStackView.distribution = .fill
        textStackView.translatesAutoresizingMaskIntoConstraints = false
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(nameLabel)
        
        contentView.addSubview(logoImageView)
        contentView.addSubview(textStackView)
        
        NSLayoutConstraint.activate([
            // Logo image (36x36) - padding left 12px
            logoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            logoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 36),
            logoImageView.heightAnchor.constraint(equalToConstant: 36),
            
            // Text stack view - gap 12px от логотипа, выравнивание слева
            textStackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 12),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
            
            // Title label (высота 18px, выравнивание слева)
            titleLabel.heightAnchor.constraint(equalToConstant: 18),
            
            // Name label (высота 18px, выравнивание слева, должен быть под черным текстом)
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Configuration
    
    func configure(with currency: Currency, isSelected: Bool) {
        // Загружаем логотип валюты
        if let imageURL = currency.image {
            logoImageView.kf.setImage(with: imageURL)
        } else {
            logoImageView.image = nil
        }
        
        // Полное название
        titleLabel.text = currency.title
        
        // Сокращенное название
        nameLabel.text = currency.name
        
        // Визуальное выделение выбранной валюты
        if isSelected {
            // Выбранная валюта: серый фон с черной обводкой 1px solid #1A1B22
            contentView.backgroundColor = UIColor(hexString: "#F7F7F8")
            contentView.layer.borderColor = UIColor(hexString: "#1A1B22").cgColor
            contentView.layer.borderWidth = 1
            titleLabel.textColor = UIColor(hexString: "#1A1B22")
            nameLabel.textColor = UIColor(hexString: "#1C9F00")
        } else {
            // Невыбранная валюта: серый фон без обводки
            contentView.backgroundColor = UIColor(hexString: "#F7F7F8")
            contentView.layer.borderColor = UIColor.clear.cgColor
            contentView.layer.borderWidth = 0
            titleLabel.textColor = UIColor(hexString: "#1A1B22")
            nameLabel.textColor = UIColor(hexString: "#1C9F00")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.kf.cancelDownloadTask()
        logoImageView.image = nil
        titleLabel.text = nil
        nameLabel.text = nil
    }
}

