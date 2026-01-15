import Foundation

/// Варианты сортировки корзины
enum CartSortOption: String, CaseIterable {
    case name = "name"
    case price = "price"
    case rating = "rating"
    
    /// Локализованное название для отображения в UI
    var displayName: String {
        switch self {
        case .name:
            return NSLocalizedString("Cart.Sort.Name", comment: "По названию")
        case .price:
            return NSLocalizedString("Cart.Sort.Price", comment: "По цене")
        case .rating:
            return NSLocalizedString("Cart.Sort.Rating", comment: "По рейтингу")
        }
    }
}

/// Утилита для сортировки NFT в корзине
struct CartSortUtility {
    
    private static let sortOptionKey = "CartSortOption"
    
    /// Сохраняет выбранный вариант сортировки в UserDefaults
    static func saveSortOption(_ option: CartSortOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortOptionKey)
    }
    
    /// Загружает сохраненный вариант сортировки из UserDefaults
    /// Возвращает сортировку по названию по умолчанию
    static func loadSortOption() -> CartSortOption {
        guard let rawValue = UserDefaults.standard.string(forKey: sortOptionKey),
              let option = CartSortOption(rawValue: rawValue) else {
            return .name // По умолчанию сортировка по названию
        }
        return option
    }
    
    /// Сортирует массив NFT согласно выбранному критерию
    static func sort(_ nfts: [CartNFT], by option: CartSortOption) -> [CartNFT] {
        switch option {
        case .name:
            return nfts.sorted { $0.name < $1.name }
        case .price:
            return nfts.sorted { $0.price < $1.price }
        case .rating:
            return nfts.sorted { $0.rating > $1.rating } // По убыванию рейтинга
        }
    }
}

