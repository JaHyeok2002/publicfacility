import Foundation

struct User: Codable, Hashable {
    let id: Int64
    let email: String
    let nickname: String
    let favoriteCount: Int?
    let recentViewCount: Int?
}
