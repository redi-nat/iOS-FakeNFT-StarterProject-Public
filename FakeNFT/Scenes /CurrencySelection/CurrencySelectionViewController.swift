import UIKit

/// Экран выбора валюты для оплаты
final class CurrencySelectionViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: CurrencySelectionPresenter
    private var currencies: [Currency] = []
    private var selectedIndex: Int?
    
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
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 7
        layout.minimumLineSpacing = 7
        layout.sectionInset = UIEdgeInsets(top: 20, left: 16, bottom: 20, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CurrencyCollectionViewCell.self)
        return collectionView
    }()
    
    private lazy var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#F7F7F8")
        view.layer.cornerRadius = 12
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("Cart.pay", comment: "Оплатить")
        button.setTitle(title, for: .normal)
        
        // Настраиваем атрибутированный текст согласно макету
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor.white,
                .paragraphStyle: paragraphStyle
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.backgroundColor = UIColor(hexString: "#1A1B22")
        button.layer.cornerRadius = 16
        button.isEnabled = true // Кнопка сразу активна
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var termsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var termsLabel: UILabel = {
        let label = UILabel()
        let text = NSLocalizedString("CurrencySelection.Terms", comment: "Совершая покупку, вы соглашаетесь с условиями")
        
        // Настраиваем атрибутированный текст согласно макету (выравнивание слева)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        label.attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor(hexString: "#1A1B22") ?? .label,
                .kern: -0.08,
                .paragraphStyle: paragraphStyle
            ]
        )
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var termsLinkButton: UIButton = {
        let button = UIButton(type: .system)
        let title = NSLocalizedString("CurrencySelection.TermsLink", comment: "Пользовательского соглашения")
        
        // Настраиваем атрибутированный текст согласно макету
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: UIFont.systemFont(ofSize: 13, weight: .regular),
                .foregroundColor: UIColor(hexString: "#0A84FF") ?? .systemBlue,
                .kern: -0.08,
                .paragraphStyle: paragraphStyle
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(termsLinkTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    init(presenter: CurrencySelectionPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
        // Скрываем tab bar на экране оплаты
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        // Настраиваем стиль заголовка согласно макету (отцентрован по горизонтали)
        title = NSLocalizedString("CurrencySelection.Title", comment: "Выберите способ оплаты")
        
        if let navigationBar = navigationController?.navigationBar {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 17, weight: .bold),
                .foregroundColor: UIColor(hexString: "#1A1B22") ?? .label
            ]
            navigationBar.titleTextAttributes = titleAttributes
        }
        
        // Добавляем кнопку назад (толстая стрелка, но меньшего размера)
        let backButton = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        backButton.setImage(UIImage(systemName: "chevron.backward", withConfiguration: config), for: .normal)
        backButton.tintColor = UIColor(hexString: "#1A1B22")
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        // Скрываем tab bar на экране оплаты
        hidesBottomBarWhenPushed = true
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        view.addSubview(bottomContainerView)
        bottomContainerView.addSubview(termsContainerView)
        termsContainerView.addSubview(termsLabel)
        termsContainerView.addSubview(termsLinkButton)
        bottomContainerView.addSubview(payButton)
        view.addSubview(activityIndicator)
        view.addSubview(loadingView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Collection view
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            
            // Bottom container view (подложка)
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Terms container view (width: 343, height: 44, left: 16px, но адаптивно)
            termsContainerView.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 16),
            termsContainerView.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            termsContainerView.trailingAnchor.constraint(lessThanOrEqualTo: bottomContainerView.trailingAnchor, constant: -16),
            termsContainerView.widthAnchor.constraint(lessThanOrEqualToConstant: 343),
            termsContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            // Terms label внутри контейнера
            termsLabel.topAnchor.constraint(equalTo: termsContainerView.topAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: termsContainerView.leadingAnchor),
            termsLabel.trailingAnchor.constraint(equalTo: termsContainerView.trailingAnchor),
            
            // Terms link button внутри контейнера (gap 4px от текста)
            termsLinkButton.topAnchor.constraint(equalTo: termsLabel.bottomAnchor, constant: 4),
            termsLinkButton.leadingAnchor.constraint(equalTo: termsContainerView.leadingAnchor),
            termsLinkButton.bottomAnchor.constraint(lessThanOrEqualTo: termsContainerView.bottomAnchor),
            
            // Pay button (адаптивная ширина с отступами 16px, gap 10px от контейнера)
            payButton.topAnchor.constraint(equalTo: termsContainerView.bottomAnchor, constant: 10),
            payButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            payButton.bottomAnchor.constraint(equalTo: bottomContainerView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // ActivityIndicator constraints (скрыт, используется для совместимости с протоколом)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Loading view
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        updatePayButtonState()
    }
    
    private func updatePayButtonState() {
        // Кнопка всегда активна согласно требованиям
        payButton.isEnabled = true
        payButton.backgroundColor = UIColor(hexString: "#1A1B22")
        payButton.setTitleColor(.white, for: .normal)
    }
    
    @objc
    private func payButtonTapped() {
        presenter.payButtonTapped()
    }
    
    @objc
    private func termsLinkTapped() {
        // TODO: Открыть WKWebView с пользовательским соглашением (задача 4.5)
        let urlString = "https://yandex.ru/legal/practicum_termsofuse"
        if let url = URL(string: urlString) {
            let webViewController = WebViewController(url: url)
            let navigationController = UINavigationController(rootViewController: webViewController)
            // Настраиваем стиль навигационного бара для непрозрачного фона
            navigationController.navigationBar.isTranslucent = false
            navigationController.navigationBar.backgroundColor = .systemBackground
            navigationController.modalPresentationStyle = .pageSheet
            present(navigationController, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource

extension CurrencySelectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let currency = currencies[indexPath.item]
        let isSelected = selectedIndex == indexPath.item
        cell.configure(with: currency, isSelected: isSelected)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CurrencySelectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        presenter.selectCurrency(at: indexPath.item)
        collectionView.reloadData()
        updatePayButtonState()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CurrencySelectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Адаптивная ширина: (ширина экрана - отступы - spacing) / 2
        let spacing: CGFloat = 7
        let insets: CGFloat = 16 * 2 // left + right
        let availableWidth = collectionView.bounds.width - insets - spacing
        let itemWidth = availableWidth / 2
        // Минимальная ширина 168px, но адаптируемся под экран
        return CGSize(width: max(168, itemWidth), height: 46)
    }
}

// MARK: - CurrencySelectionView

extension CurrencySelectionViewController: CurrencySelectionView {
    func displayCurrencies(_ currencies: [Currency]) {
        self.currencies = currencies
        collectionView.reloadData()
    }
    
    func updatePayButton(enabled: Bool) {
        selectedIndex = enabled ? selectedIndex : nil
        updatePayButtonState()
        collectionView.reloadData()
    }
    
    func showPaymentSuccess() {
        let successViewController = PaymentSuccessViewController()
        successViewController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        present(successViewController, animated: true)
    }
}

// MARK: - LoadingView Implementation

extension CurrencySelectionViewController {
    func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
    }
    
    func hideLoading() {
        loadingView.stopAnimating()
        loadingView.isHidden = true
    }
}

// MARK: - WebViewController (временный класс для открытия ссылки)

import WebKit

final class WebViewController: UIViewController {
    private let url: URL
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        return webView
    }()
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Устанавливаем непрозрачный фон для view
        view.backgroundColor = .systemBackground
        
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneTapped)
        )
        
        webView.load(URLRequest(url: url))
    }
    
    @objc private func doneTapped() {
        dismiss(animated: true)
    }
}

