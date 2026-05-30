import Foundation
import Combine

@MainActor
final class FavoriteViewModel: ObservableObject {
    @Published var favorites: [Facility] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let favoriteService = FavoriteService()
    
    func fetchFavorites() async {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            favorites = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            favorites = try await favoriteService.fetchFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func addFavorite(facility: Facility) async {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            return
        }
        
        do {
            try await favoriteService.addFavorite(facility: facility)
            await fetchFavorites()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteFavorite(facilityId: Int64) async {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            return
        }
        
        do {
            try await favoriteService.deleteFavorite(facilityId: facilityId)
            favorites.removeAll { $0.id == facilityId }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
