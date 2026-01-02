import Foundation

/// Протокол для View в архитектуре MVP
protocol CartView: AnyObject, ErrorView, LoadingView {
    /// Отображает список NFT в корзине
    func displayNFTs(_ nfts: [CartNFT])
    
    /// Обновляет нижнюю панель с итогами
    func updateSummary(count: Int, total: Double)
}

