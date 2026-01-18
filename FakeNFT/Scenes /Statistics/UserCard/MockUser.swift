import Foundation

#if DEBUG
struct MockUser {
    static let joaquinPhoenix = User(
        id: "1",
        name: "Joaquin Phoenix",
        avatar: "https://example.com/avatar.jpg",
        description: "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте. Открыт к коллаборациям.",
        website: "https://practicum.yandex.ru/ios-developer/",
        nfts: Array(repeating: "nft_id", count: 112),
        rating: "5"
    )
    
    static let testUsers: [User] = [
        joaquinPhoenix,
        User(
            id: "2",
            name: "Алексей Иванов",
            avatar: "",
            description: "Коллекционер современного искусства",
            website: "https://example.com",
            nfts: Array(repeating: "nft_id", count: 50),
            rating: "4"
        )
    ]
}
#endif
