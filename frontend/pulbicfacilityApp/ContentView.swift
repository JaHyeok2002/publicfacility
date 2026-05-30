import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        if authViewModel.isLoggedIn {
            MainTabView {
                authViewModel.logout()
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
