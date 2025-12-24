import UIKit
import Foundation

/// Экран корзины
final class CartViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CartPresenter
    private var cartItems: [CartNFTCellModel] = []
    
    // MARK: - UI Elements
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Используем кастомный LoadingView, но для совместимости с протоколом LoadingView
        // оставляем UIActivityIndicatorView и управляем им через loadingView
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var loadingView: CartLoadingView = {
        let view = CartLoadingView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.register(CartNFTTableViewCell.self)
        return tableView
    }()
    
    private lazy var summaryView: CartSummaryView = {
        let view = CartSummaryView()
        view.onPay = { [weak self] in
            self?.payButtonTapped()
        }
        return view
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Cart.empty", comment: "Корзина пуста")
        label.font = .bodyBold // SF Pro Text, Bold, 17px
        label.textColor = UIColor(hexString: "#1A1B22")
        label.textAlignment = .center
        label.numberOfLines = 1
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    init(presenter: CartPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var sortButton: UIButton = {
        let button = UIButton(type: .system)
        // Иконка сортировки/фильтра - используем кастомную иконку из Assets
        let sortImage = UIImage(named: "filtr")?.withRenderingMode(.alwaysTemplate)
        button.setImage(sortImage, for: .normal)
        button.tintColor = .tabBarInactive // Цвет #1A1B22
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        
        // Настраиваем imageView для правильного масштабирования
        button.imageView?.contentMode = .scaleAspectFit
        
        // Увеличиваем размер иконки, сохраняя пропорции
        // Используем imageEdgeInsets для позиционирования и увеличения размера
        // Увеличиваем размер примерно в 1.5-2 раза для лучшей видимости
        let scale: CGFloat = 1.8
        let iconWidth: CGFloat = 21 * scale
        let iconHeight: CGFloat = 12.6 * scale
        
        // Рассчитываем отступы для центрирования увеличенной иконки
        let horizontalInset = (42 - iconWidth) / 2
        let verticalInset = (42 - iconHeight) / 2
        
        button.imageEdgeInsets = UIEdgeInsets(
            top: verticalInset,
            left: horizontalInset,
            bottom: verticalInset,
            right: horizontalInset
        )
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupUI()
        view.backgroundColor = .systemBackground
        presenter.viewDidLoad()
    }
    
    // MARK: - Private Methods
    
    private func setupNavigationBar() {
        // Убираем заголовок "Корзина" согласно макету
        title = nil
        
        // Настройка Navigation Bar согласно макету
        // Height: 42, но iOS автоматически управляет высотой Navigation Bar
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Добавляем кнопку сортировки справа
        // Размер кнопки: 42x42 согласно макету
        let sortBarButton = UIBarButtonItem(customView: sortButton)
        navigationItem.rightBarButtonItem = sortBarButton
        
        // Настройка размеров кнопки
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sortButton.widthAnchor.constraint(equalToConstant: 42),
            sortButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupUI() {
        // Сначала добавляем все view в иерархию
        view.addSubview(tableView)
        view.addSubview(summaryView)
        view.addSubview(activityIndicator)
        view.addSubview(loadingView)
        view.addSubview(emptyStateLabel)
        
        // Настраиваем translatesAutoresizingMaskIntoConstraints
        tableView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        
        // Теперь создаем все constraints
        NSLayoutConstraint.activate([
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: summaryView.topAnchor),
            
            // SummaryView constraints
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            summaryView.heightAnchor.constraint(equalToConstant: 76),
            
            // ActivityIndicator constraints (скрыт, используется для совместимости с протоколом)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // LoadingView constraints - центрирование для адаптации под разные устройства
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // EmptyStateLabel constraints - центрирование по экрану для адаптации под разные устройства
            emptyStateLabel.heightAnchor.constraint(equalToConstant: 22),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor), // По центру экрана по вертикали
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    @objc
    private func sortButtonTapped() {
        // TODO: Реализовать открытие меню сортировки (задача 2.5)
        print("Sort button tapped")
    }
    
    private func payButtonTapped() {
        // TODO: Реализовать переход на экран выбора валюты (задача 2.8)
        print("Pay button tapped")
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartNFTTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
        let item = cartItems[indexPath.row]
        cell.configure(with: item)
        cell.onDelete = { [weak self] in
            self?.presenter.deleteNFT(id: item.id)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140 // Высота ячейки согласно макету (108 + padding 16*2)
    }
}

// MARK: - CartView

extension CartViewController: CartView {
    func displayNFTs(_ nfts: [CartNFT]) {
        // Сначала гарантированно скрываем заглушку загрузки синхронно
        loadingView.stopAnimating()
        loadingView.isHidden = true
        // Принудительно обновляем layout, чтобы гарантировать скрытие
        view.layoutIfNeeded()
        
        // Конвертируем CartNFT в CartNFTCellModel
        cartItems = nfts.map { nft in
            CartNFTCellModel(
                id: nft.id,
                imageURL: nft.images.first, // Берем первое изображение
                name: nft.name,
                rating: nft.rating,
                price: nft.price
            )
        }
        
        // Показываем/скрываем заглушку и панель оплаты в зависимости от состояния корзины
        let isEmpty = cartItems.isEmpty
        emptyStateLabel.isHidden = !isEmpty
        tableView.isHidden = isEmpty
        summaryView.isHidden = isEmpty // Показываем панель оплаты только если корзина не пустая
        
        tableView.reloadData()
    }
    
    func updateSummary(count: Int, total: Double) {
        summaryView.update(count: count, total: total)
    }
}

// MARK: - LoadingView Implementation

extension CartViewController {
    func showLoading() {
        loadingView.startAnimating()
        summaryView.isHidden = true // Скрываем панель оплаты во время загрузки
    }
    
    func hideLoading() {
        // Скрываем заглушку синхронно, чтобы гарантировать скрытие
        loadingView.stopAnimating()
        loadingView.isHidden = true
        // Принудительно обновляем layout, чтобы гарантировать скрытие
        view.layoutIfNeeded()
        // Панель оплаты будет показана/скрыта в displayNFTs в зависимости от наличия товаров
    }
}


