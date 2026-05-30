import Foundation
import Combine

@MainActor
final class UserViewModel: ObservableObject {
    @Published var user: User?
    @Published var recentFacilities: [Facility] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userService = UserService()
    
    func fetchMyPage() async {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.fetchMe()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchRecentFacilities() async {
        guard APIClient.shared.accessToken != nil else {
            recentFacilities = []
            return
        }
        
        do {
            recentFacilities = try await userService.fetchRecentFacilities()
        } catch {
            print("최근 조회 조회 실패:", error.localizedDescription)
        }
    }
    
    func deleteMe() async -> Bool {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            return false
        }
        
        do {
            try await userService.deleteMe()
            APIClient.shared.accessToken = nil
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}
