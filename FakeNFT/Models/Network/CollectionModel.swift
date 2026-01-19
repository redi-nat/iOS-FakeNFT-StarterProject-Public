import Foundation

struct CollectionModel: Codable {
    let id: String
    let name: String
    let cover: URL
    let nfts: [String]
    let description: String
    let author: String
}
