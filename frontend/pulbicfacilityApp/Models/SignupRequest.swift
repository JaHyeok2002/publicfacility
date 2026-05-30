import Foundation

struct SignupRequest: Codable {
    let email: String
    let password: String
    let nickname: String
}
