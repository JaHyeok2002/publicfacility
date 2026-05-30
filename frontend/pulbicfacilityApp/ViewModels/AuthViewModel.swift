import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var nickname = ""
    @Published var confirmPassword = ""
    
    @Published var isLoggedIn: Bool = APIClient.shared.accessToken != nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService = AuthService()
    
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "이메일과 비밀번호를 입력해주세요."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            APIClient.shared.accessToken = response.accessToken
            isLoggedIn = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func signup() async -> Bool {
        guard !email.isEmpty, !password.isEmpty, !nickname.isEmpty else {
            errorMessage = "모든 항목을 입력해주세요."
            return false
        }
        
        guard password == confirmPassword else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.signup(
                email: email,
                password: password,
                nickname: nickname
            )
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }
    
    func logout() {
        APIClient.shared.accessToken = nil
        isLoggedIn = false
        email = ""
        password = ""
        nickname = ""
        confirmPassword = ""
    }
}
