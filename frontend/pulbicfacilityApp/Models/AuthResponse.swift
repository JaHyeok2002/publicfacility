import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let tokenType: String
    let user: User
}
