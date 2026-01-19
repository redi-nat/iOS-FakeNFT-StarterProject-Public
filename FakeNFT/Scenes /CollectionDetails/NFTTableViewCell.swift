import UIKit
import Kingfisher

final class NFTCollectionCell: UICollectionViewCell {
    
    // MARK: - UI Elements
    private let nftImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "like_off"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let ratingView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 2
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart_empty"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    var onLikeButtonTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        cartButton.addTarget(self, action: #selector(cartTapped), for: .touchUpInside)
    }

    required init?(coder: NSCoder) { fatalError() }

    @objc private func likeTapped() {
            onLikeButtonTapped?()
        }
    
    @objc private func cartTapped() {
            onCartButtonTapped?()
        }
    
    // MARK: - Configuration
    func configure(with model: Nft, isLiked: Bool, isInCart: Bool) {
        nameLabel.text = model.name
        priceLabel.text = "\(model.price) ETH"
        
        if let url = model.images.first {
            nftImageView.kf.setImage(with: url)
        }
        
        setupRating(model.rating)
        
        let imageName = isLiked ? "like_on" : "like_off"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
        
        let cartImage = isInCart ? "cart_full" : "cart_empty"
        cartButton.setImage(UIImage(named: cartImage), for: .normal)
    }

    private func setupRating(_ rating: Int) {
        ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...5 {
            let star = UIImageView()
            let imageName = i <= rating ? "star_done" : "star_default"
            star.image = UIImage(named: imageName)
            star.contentMode = .scaleAspectFit
            
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            star.heightAnchor.constraint(equalToConstant: 12).isActive = true
            
            ratingView.addArrangedSubview(star)
        }
    }

    private func setupLayout() {
        contentView.addSubview(nftImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingView)
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        
        let bottomStack = UIStackView(arrangedSubviews: [infoStack, cartButton])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .top
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bottomStack)

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ratingView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 68),
            
            bottomStack.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
