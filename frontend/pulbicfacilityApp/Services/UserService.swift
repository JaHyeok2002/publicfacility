import Foundation

final class UserService {
    
    func fetchMe() async throws -> User {
        return try await APIClient.shared.request(path: "/api/users/me")
    }
    
    func fetchRecentFacilities() async throws -> [Facility] {
        return try await APIClient.shared.request(path: "/api/users/me/recent-facilities")
    }
    
    func deleteMe() async throws {
        try await APIClient.shared.requestWithoutResponse(
            path: "/api/users/me",
            method: "DELETE"
        )
    }
}
