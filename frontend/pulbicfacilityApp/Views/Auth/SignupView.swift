import SwiftUI

struct SignupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.primary)
                }
                
                Text("회원가입")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.leading, 12)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .padding(.bottom, 28)
            .background(Color.white)
            
            VStack(spacing: 16) {
                inputField(
                    icon: "envelope",
                    color: .blue,
                    placeholder: "이메일",
                    text: $authViewModel.email,
                    isSecure: false
                )
                
                inputField(
                    icon: "lock",
                    color: .green,
                    placeholder: "비밀번호",
                    text: $authViewModel.password,
                    isSecure: true
                )
                
                inputField(
                    icon: "lock",
                    color: .green,
                    placeholder: "비밀번호 확인",
                    text: $authViewModel.confirmPassword,
                    isSecure: true
                )
                
                inputField(
                    icon: "person",
                    color: .purple,
                    placeholder: "닉네임",
                    text: $authViewModel.nickname,
                    isSecure: false
                )
                
                if let errorMessage = authViewModel.errorMessage {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button {
                    Task {
                        let success = await authViewModel.signup()
                        if success {
                            dismiss()
                        }
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("회원가입")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(Color.blue)
                .cornerRadius(14)
                .padding(.top, 12)
                
                HStack {
                    Text("이미 계정이 있으신가요?")
                        .foregroundColor(.secondary)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text("로그인하기")
                            .foregroundColor(.blue)
                            .fontWeight(.semibold)
                    }
                }
                .font(.subheadline)
                .padding(.top, 8)
            }
            .padding(.horizontal, 28)
            .padding(.top, 32)
            
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func inputField(
        icon: String,
        color: Color,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.14))
                .clipShape(Circle())
            
            if isSecure {
                SecureField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            } else {
                TextField(placeholder, text: text)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    SignupView()
}
