import Foundation

final class FavoriteService {
    
    func fetchFavorites() async throws -> [Facility] {
        return try await APIClient.shared.request(path: "/api/favorites")
    }
    
    func addFavorite(facility: Facility) async throws {
        let requestBody = FavoriteRequest(facility: facility)
        let body = try JSONEncoder().encode(requestBody)
        
        try await APIClient.shared.requestWithoutResponse(
            path: "/api/favorites",
            method: "POST",
            body: body
        )
    }
    
    func deleteFavorite(facilityId: Int64) async throws {
        try await APIClient.shared.requestWithoutResponse(
            path: "/api/favorites/\(facilityId)",
            method: "DELETE"
        )
    }
}
