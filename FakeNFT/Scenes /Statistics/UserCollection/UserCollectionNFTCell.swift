import UIKit
import Kingfisher

protocol NFTCollectionCellDelegate: AnyObject {
    func didTapLikeButton(in cell: UserNFTCollectionCell)
    func didTapCartButton(in cell: UserNFTCollectionCell)
}

final class UserNFTCollectionCell: UICollectionViewCell, ReuseIdentifying {
    weak var delegate: NFTCollectionCellDelegate?
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .likeOff), for: .normal)
        button.backgroundColor = .clear
        button.addAction(UIAction { [weak self] _ in
            self?.likeButtonTapped()
        }, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 2
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.textAlignment = .left
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .cartEmpty), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addAction(UIAction { [weak self] _ in
            self?.cartButtonTapped()
        }, for: .touchUpInside)
        return button
    }()
    
    private var isLiked: Bool = false {
        didSet {
            let imageName = isLiked ? "like_on" : "like_off"
            likeButton.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    private var isInCart: Bool = false {
        didSet {
            cartButton.setImage(isInCart ? UIImage(named: "cart_full") : UIImage(named: "cart_empty"), for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(ratingView)
        
        let infoStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        infoStack.axis = .vertical
        infoStack.spacing = 4
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomStack = UIStackView(arrangedSubviews: [infoStack, cartButton])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.distribution = .fill
        bottomStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalTo: likeButton.heightAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 68),
            
            bottomStack.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 5),
            bottomStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configure(with nft: UserNFT, isLiked: Bool, isInCart: Bool) {
        nameLabel.text = nft.name
        priceLabel.text = nft.formattedPrice
        self.isLiked = isLiked
        self.isInCart = isInCart
        
        setupRating(rating: nft.rating)
        
        if let url = nft.firstImageURL {
            imageView.kf.setImage(with: url,
                                  placeholder: UIImage(systemName: "photo"),
                                  options: [.transition(.fade(0.2))]
            )
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func setupRating(rating: Int) {
        ratingView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...5 {
            let starImageView = UIImageView()
            starImageView.image = UIImage(named: i <= rating ? "star_done" : "star_default")
            starImageView.contentMode = .scaleAspectFit
            
            ratingView.addArrangedSubview(starImageView)
            
        }
    }
    private func likeButtonTapped() {
        isLiked.toggle()
        delegate?.didTapLikeButton(in: self)
    }
    private func  cartButtonTapped() {
        isInCart.toggle()
        delegate?.didTapCartButton(in: self)
    }
}
