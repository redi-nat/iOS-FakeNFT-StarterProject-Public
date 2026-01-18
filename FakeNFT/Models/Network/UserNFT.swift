
import Foundation

struct UserNFT: Decodable {
    let id: String
    let name: String
    let images: [String] 
    let rating: Int
    let price: Double
    let description: String?
    let author: String?
    let website: String?
    
    var firstImageURL: URL? {
        guard let firstImage = images.first else { return nil }
        return URL(string: firstImage)
    }
    
    var formattedPrice: String {
        String(format: "%.2f ETH", price)
    }
}
