import Foundation

/// Модель заказа (корзины)
/// Представляет ответ API при запросе корзины
struct Order: Decodable {
    let id: String
    let nfts: [CartNFT]
    
    // Возможно, API возвращает дополнительные поля:
    // - totalPrice: Double
    // - currencyId: String
    // - createdAt: Date
    // и т.д. - нужно уточнить по реальному API ответу
}

