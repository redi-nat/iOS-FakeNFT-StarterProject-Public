import Foundation

protocol UserCardPresenterProtocol {
    var onWebsiteTap: ((URL) -> Void)? { get set }
    var onCollectionTap:((User) -> Void)? { get set }
    
    func viewDidLoad(with userId: String)
    func toUserWebsiteGo()
    func toUserCollectonNFTGo()
}

final class UserCardPresenter: UserCardPresenterProtocol {
    
    // Mark: – Properties
    weak var view: UserCardViewProtocol?
    private let usersService: UsersService
    private var user: User?
    var onWebsiteTap: ((URL) -> Void)?
    var onCollectionTap:((User) -> Void)?
    
    // Mark: – Initializer
    init(usersService: UsersService) {
        self.usersService = usersService
    }
    
    // Mark: – Public Methods
    func viewDidLoad(with userId: String) {
        loadUser(id: userId)
    }
    
    func toUserWebsiteGo() {
        guard let user = user,
              let url = URL(string: user.website) else {
            return
        }
        onWebsiteTap?(url)
    }
    
    func toUserCollectonNFTGo() {
        guard let user = user else {
            return
        }
        onCollectionTap?(user)
    }
    
    // Mark: Private Methods
    private func loadUser(id: String) {
        view?.showLoading()
        
        usersService.loadUser(id: id) { [weak self] result in
            guard let self else {
                return
            }
            
            self.view?.hideLoading()
            
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.view?.displayUserData(user)
                case .failure (let error):
                    self.view?.showError("Не удалось загрузить данные пользователя. \(error.localizedDescription)")
                }
            }
        }
    }
}
