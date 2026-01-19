import Foundation

/// Модель NFT в корзине
/// Содержит все необходимые данные для отображения NFT в корзине
struct CartNFT: Decodable {
    let id: String
    let name: String
    let images: [URL]
    let rating: Int
    let price: Double  // цена в ETH
    
    // Если API возвращает цену как строку, можно добавить кастомный декодер
    // или если структура полей отличается, нужно будет скорректировать
}

