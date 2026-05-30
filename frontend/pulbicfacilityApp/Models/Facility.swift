import Foundation

struct Facility: Identifiable, Codable, Hashable {
    let id: Int64
    let name: String
    let category: String
    let categoryName: String
    let address: String
    let latitude: Double
    let longitude: Double
    let distance: Double?
    let openTime: String
    let phone: String
    let amenities: [String]
    var favorite: Bool
}
