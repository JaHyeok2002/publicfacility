import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = FacilityViewModel()
    @State private var selectedCategory: String? = nil
    @State private var selectedFacility: Facility?
    
    private let categories: [(title: String, code: String, icon: String, color: Color)] = [
        ("공공화장실", "TOILET", "drop", .blue),
        ("무더위쉼터", "SHELTER", "mappin.circle", .green),
        ("공공와이파이", "WIFI", "wifi", .purple)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    headerView
                    categorySection
                    recommendationSection
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .task {
                await viewModel.fetchFacilities()
            }
            .navigationDestination(item: $selectedFacility) { facility in
                FacilityDetailView(facility: facility)
            }
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("공공시설 안내")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("내 주변 공공시설을 찾아보세요")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var categorySection: some View {
        HStack(spacing: 12) {
            ForEach(categories, id: \.code) { category in
                NavigationLink {
                    FacilityListView(initialCategory: category.code)
                } label: {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(category.color)
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: category.icon)
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        
                        Text(category.title)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(18)
                    .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var recommendationSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("추천 시설")
                .font(.title3)
                .fontWeight(.bold)
            
            if viewModel.isLoading {
                LoadingView()
                    .frame(height: 180)
            } else if viewModel.facilities.isEmpty {
                EmptyStateView(icon: "tray", message: "추천 시설이 없어요")
                    .frame(height: 180)
            } else {
                VStack(spacing: 14) {
                    ForEach(Array(viewModel.facilities.prefix(3))) { facility in
                        FacilityCardView(
                            facility: facility,
                            onFavoriteTap: {
                                Task {
                                    await viewModel.toggleFavorite(facility: facility)
                                }
                            },
                            onCardTap: {
                                selectedFacility = facility
                            }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
