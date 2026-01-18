import Foundation

final class ServicesAssembly {
    
    let networkClient: NetworkClient
    private let nftStorage: NftStorage
  
    // Хранимые свойства для сервисов, чтобы сохранялось состояние между вызовами
    private lazy var _nftService: NftService = {
        NftServiceImpl(
            networkClient: networkClient,
            storage: nftStorage
        )
    }()
    
    private lazy var _cartService: CartService = {
        CartServiceImpl(networkClient: networkClient)
    }()
    
    private lazy var _currencyService: CurrencyService = {
        CurrencyServiceImpl(networkClient: networkClient)
    }()
    
    private lazy var _paymentService: PaymentService = {
        PaymentServiceImpl(networkClient: networkClient)
    }()
    
    private lazy var _profileService: ProfileService = {
        ProfileServiceImpl(networkClient: networkClient, nftStorage: nftStorage)
    }()

    init(
        networkClient: NetworkClient,
        nftStorage: NftStorage
    ) {
        self.networkClient = networkClient
        self.nftStorage = nftStorage
    }
    
    var nftService: NftService {
        _nftService
    }
    
    var cartService: CartService {
        _cartService
    }
    
    var currencyService: CurrencyService {
        _currencyService
    }
    
    var paymentService: PaymentService {
        _paymentService
    }
    
    var profileService: ProfileService {
        _profileService
    }
    var usersService: UsersService {
        UsersServiceImpl(
            networkClient: networkClient
        )
    }
    
    var likesService: LikesService {
        LikesServiceImpl(
            networkClient: networkClient
        )
    }
}
