import SwiftUI

struct MyPageView: View {
    @StateObject private var userViewModel = UserViewModel()
    @StateObject private var favoriteViewModel = FavoriteViewModel()
    
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    
    var onLogout: (() -> Void)?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    headerView
                    
                    if APIClient.shared.accessToken == nil {
                        loginRequiredView
                    } else {
                        profileCard
                        statsSection
                        recentSection
                        actionSection
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 36)
            }
            .background(Color(.systemGroupedBackground))
            .task {
                await loadData()
            }
            .refreshable {
                await loadData()
            }
            .alert("로그아웃", isPresented: $showLogoutAlert) {
                Button("취소", role: .cancel) {}
                Button("로그아웃", role: .destructive) {
                    APIClient.shared.accessToken = nil
                    onLogout?()
                }
            } message: {
                Text("정말 로그아웃하시겠습니까?")
            }
            .alert("회원 탈퇴", isPresented: $showDeleteAlert) {
                Button("취소", role: .cancel) {}
                Button("탈퇴", role: .destructive) {
                    Task {
                        let success = await userViewModel.deleteMe()
                        if success {
                            APIClient.shared.accessToken = nil
                            onLogout?()
                        }
                    }
                }
            } message: {
                Text("회원 탈퇴 시 계정 정보가 삭제됩니다.")
            }
        }
    }
    
    private var headerView: some View {
        Text("마이페이지")
            .font(.title2)
            .fontWeight(.bold)
    }
    
    private var loginRequiredView: some View {
        EmptyStateView(
            icon: "person.crop.circle.badge.exclamationmark",
            message: "로그인이 필요한 화면입니다."
        )
        .frame(height: 400)
    }
    
    private var profileCard: some View {
        HStack(spacing: 18) {
            Image(systemName: "person")
                .font(.system(size: 34))
                .foregroundColor(.white)
                .frame(width: 72, height: 72)
                .background(Color.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 6) {
                Text(userViewModel.user?.nickname ?? "사용자")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(userViewModel.user?.email ?? "-")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
    
    private var statsSection: some View {
        HStack(spacing: 14) {
            statCard(
                icon: "heart",
                iconColor: .red,
                title: "내 즐겨찾기",
                value: "\(favoriteViewModel.favorites.count)"
            )
            
            statCard(
                icon: "clock",
                iconColor: .blue,
                title: "최근 조회",
                value: "\(userViewModel.recentFacilities.count)"
            )
        }
    }
    
    private func statCard(
        icon: String,
        iconColor: Color,
        title: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 42, height: 42)
                .background(iconColor.opacity(0.14))
                .clipShape(Circle())
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
    
    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("최근 조회한 시설")
                .font(.headline)
                .fontWeight(.bold)
            
            if userViewModel.recentFacilities.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock")
                        .font(.title2)
                        .foregroundColor(.green)
                        .frame(width: 46, height: 46)
                        .background(Color.green.opacity(0.14))
                        .clipShape(Circle())
                    
                    Text("최근 조회한 시설이 없어요")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            } else {
                VStack(spacing: 10) {
                    ForEach(userViewModel.recentFacilities.prefix(3)) { facility in
                        NavigationLink {
                            FacilityDetailView(facility: facility)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(facility.name)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Text(facility.categoryName)
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            }
        }
    }
    
    private var actionSection: some View {
        VStack(spacing: 12) {
            Button {
                showLogoutAlert = true
            } label: {
                Label("로그아웃", systemImage: "rectangle.portrait.and.arrow.right")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.06), radius: 5, x: 0, y: 2)
            }
            
            Button {
                showDeleteAlert = true
            } label: {
                Label("회원 탈퇴", systemImage: "trash")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
    }
    
    private func loadData() async {
        await userViewModel.fetchMyPage()
        await userViewModel.fetchRecentFacilities()
        await favoriteViewModel.fetchFavorites()
    }
}

#Preview {
    MyPageView()
}
