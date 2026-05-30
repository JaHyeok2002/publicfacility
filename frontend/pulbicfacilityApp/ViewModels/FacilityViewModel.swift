import Foundation
import Combine

@MainActor
final class FacilityViewModel: ObservableObject {
    @Published var facilities: [Facility] = []
    @Published var selectedCategory: String? = nil
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let facilityService = FacilityService()
    private let favoriteService = FavoriteService()
    
    func fetchFacilities(category: String? = nil) async {
        isLoading = true
        errorMessage = nil
        selectedCategory = category
        
        do {
            facilities = try await facilityService.fetchFacilities(category: category)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchNearby(lat: Double = 37.5665, lng: Double = 126.9780) async {
        isLoading = true
        errorMessage = nil
        selectedCategory = nil
        
        do {
            facilities = try await facilityService.fetchNearby(lat: lat, lng: lng)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchNearbyByCategory(category: String, lat: Double, lng: Double) async {
        isLoading = true
        errorMessage = nil
        selectedCategory = category
        
        do {
            facilities = try await facilityService.fetchNearbyByCategory(
                category: category,
                lat: lat,
                lng: lng
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func fetchDetail(facilityId: Int64) async -> Facility? {
        do {
            return try await facilityService.fetchDetail(facilityId: facilityId)
        } catch {
            print("상세 조회 실패:", error.localizedDescription)
            return nil
        }
    }
    
    func toggleFavorite(facility: Facility) async {
        guard APIClient.shared.accessToken != nil else {
            errorMessage = "로그인이 필요한 기능입니다."
            return
        }
        
        do {
            if facility.favorite {
                try await favoriteService.deleteFavorite(facilityId: facility.id)
            } else {
                try await favoriteService.addFavorite(facility: facility)
            }
            
            if let index = facilities.firstIndex(where: { $0.id == facility.id }) {
                facilities[index].favorite.toggle()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
