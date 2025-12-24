import Foundation

/// Модель для ячейки NFT в корзине
struct CartNFTCellModel {
    let id: String
    let imageURL: URL?
    let name: String
    let rating: Int // от 0 до 5
    let price: Double // цена в ETH
}

