import Foundation

struct FavoriteRequest: Codable {
    let facilityId: Int64
    let name: String
    let category: String
    let address: String
    let latitude: Double
    let longitude: Double
    let openTime: String
    let phone: String
    let amenities: [String]
    
    init(facility: Facility) {
        self.facilityId = facility.id
        self.name = facility.name
        self.category = facility.category
        self.address = facility.address
        self.latitude = facility.latitude
        self.longitude = facility.longitude
        self.openTime = facility.openTime
        self.phone = facility.phone
        self.amenities = facility.amenities
    }
}
