import Foundation

final class AuthService {
    
    func login(email: String, password: String) async throws -> AuthResponse {
        let requestBody = LoginRequest(email: email, password: password)
        let body = try JSONEncoder().encode(requestBody)
        
        return try await APIClient.shared.request(
            path: "/api/auth/login",
            method: "POST",
            body: body
        )
    }
    
    func signup(email: String, password: String, nickname: String) async throws {
        let requestBody = SignupRequest(
            email: email,
            password: password,
            nickname: nickname
        )
        let body = try JSONEncoder().encode(requestBody)
        
        try await APIClient.shared.requestWithoutResponse(
            path: "/api/auth/signup",
            method: "POST",
            body: body
        )
    }
}
