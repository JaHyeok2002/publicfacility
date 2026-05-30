import SwiftUI

struct MainTabView: View {
    var onLogout: (() -> Void)? = nil
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            NavigationStack {
                FacilityListView()
            }
            .tabItem {
                Image(systemName: "list.bullet")
                Text("목록")
            }
            
            FacilityMapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("지도")
                }
            
            FavoriteView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("즐겨찾기")
                }
            
            MyPageView {
                APIClient.shared.accessToken = nil
                onLogout?()
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("마이페이지")
            }
        }
        .tint(.blue)
    }
}

#Preview {
    MainTabView()
}
