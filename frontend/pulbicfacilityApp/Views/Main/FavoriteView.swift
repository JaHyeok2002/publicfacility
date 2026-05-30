import SwiftUI

struct FavoriteView: View {
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var selectedFacility: Facility?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                contentView
            }
            .background(Color(.systemGroupedBackground))
            .task {
                await viewModel.fetchFavorites()
            }
            .refreshable {
                await viewModel.fetchFavorites()
            }
            .navigationDestination(item: $selectedFacility) { facility in
                FacilityDetailView(facility: facility)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("즐겨찾기")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
        .padding(.bottom, 16)
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var contentView: some View {
        if APIClient.shared.accessToken == nil {
            EmptyStateView(
                icon: "person.crop.circle.badge.exclamationmark",
                message: "로그인이 필요한 기능입니다."
            )
        } else if viewModel.isLoading {
            LoadingView()
        } else if viewModel.favorites.isEmpty {
            EmptyStateView(
                icon: "tray",
                message: "아직 저장한 시설이 없어요"
            )
        } else {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.favorites) { facility in
                        favoriteCard(facility)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }
        }
    }
    
    private func favoriteCard(_ facility: Facility) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                selectedFacility = facility
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text(facility.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(facility.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 8) {
                        Text(facility.categoryName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.blue.opacity(0.12))
                            .clipShape(Capsule())
                        
                        if let distance = facility.distance {
                            Label("\(Int(distance))m", systemImage: "location")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
            
            Button {
                Task {
                    await viewModel.deleteFavorite(facilityId: facility.id)
                }
            } label: {
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundColor(.red)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}

#Preview {
    FavoriteView()
}
