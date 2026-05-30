import Foundation

final class FacilityService {
    
    func fetchFacilities(category: String? = nil) async throws -> [Facility] {
        var path = "/api/facilities"
        
        if let category = category {
            path += "?category=\(category)"
        }
        
        return try await APIClient.shared.request(path: path)
    }
    
    func fetchNearby(lat: Double, lng: Double) async throws -> [Facility] {
        let path = "/api/facilities/nearby?lat=\(lat)&lng=\(lng)"
        return try await APIClient.shared.request(path: path)
    }
    
    func fetchNearbyByCategory(category: String, lat: Double, lng: Double) async throws -> [Facility] {
        let path = "/api/facilities/nearby?lat=\(lat)&lng=\(lng)&category=\(category)"
        return try await APIClient.shared.request(path: path)
    }
    
    func fetchDetail(facilityId: Int64) async throws -> Facility {
        let path = "/api/facilities/\(facilityId)"
        return try await APIClient.shared.request(path: path)
    }
}
