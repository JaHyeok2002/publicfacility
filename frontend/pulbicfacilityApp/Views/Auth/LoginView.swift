import SwiftUI

struct LoginView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSignup = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("공공시설 안내")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("내 주변 공공시설을 쉽고 빠르게 찾아보세요")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 28)
                .padding(.top, 80)
                .padding(.bottom, 48)
                
                VStack(spacing: 18) {
                    inputField(
                        icon: "envelope",
                        placeholder: "이메일",
                        text: $authViewModel.email,
                        isSecure: false
                    )
                    
                    inputField(
                        icon: "lock",
                        placeholder: "비밀번호",
                        text: $authViewModel.password,
                        isSecure: true
                    )
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        Task {
                            await authViewModel.login()
                        }
                    } label: {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("로그인")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(Color.blue)
                    .cornerRadius(14)
                    
                    Button {
                        showSignup = true
                    } label: {
                        Text("회원가입")
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
                    }
                    
                    Button {
                        
                    } label: {
                        Text("비밀번호 찾기")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 28)
                
                Spacer()
            }
            .background(Color(.systemGroupedBackground))
            .navigationDestination(isPresented: $showSignup) {
                SignupView()
            }
            .fullScreenCover(isPresented: $authViewModel.isLoggedIn) {
                MainTabView()
            }
        }
    }
    
    @ViewBuilder
    private func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 36, height: 36)
                .background(Color.blue.opacity(0.12))
                .clipShape(Circle())
            
            if isSecure {
                SecureField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } else {
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    LoginView()
}
