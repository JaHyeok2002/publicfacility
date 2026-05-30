import SwiftUI

struct FacilityListView: View {
    let initialCategory: String?
    
    @State private var selectedFacility: Facility?
    @StateObject private var viewModel = FacilityViewModel()
    @State private var selectedCategory: String
    
    private let categories: [(title: String, code: String)] = [
        ("공공화장실", "TOILET"),
        ("무더위쉼터", "SHELTER"),
        ("공공와이파이", "WIFI")
    ]
    
    init(initialCategory: String? = nil) {
        self.initialCategory = initialCategory
        _selectedCategory = State(initialValue: initialCategory ?? "TOILET")
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                
                filterView
                
                contentView
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.fetchFacilities(category: selectedCategory)
            }
            .refreshable {
                await viewModel.fetchFacilities(category: selectedCategory)
            }
            .navigationDestination(item: $selectedFacility) { facility in
                FacilityDetailView(facility: facility)
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(categoryTitle(selectedCategory))
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal, 22)
        .padding(.top, 20)
        .padding(.bottom, 14)
        .background(Color(.systemGroupedBackground))
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.code) { category in
                    Button {
                        selectedCategory = category.code
                        selectedFacility = nil
                        
                        Task {
                            await viewModel.fetchFacilities(category: category.code)
                        }
                    } label: {
                        Text(category.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(selectedCategory == category.code ? .white : .blue)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(selectedCategory == category.code ? Color.blue : Color.white)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 14)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            LoadingView()
        } else if viewModel.facilities.isEmpty {
            EmptyStateView(icon: "tray", message: "시설 정보가 없어요")
        } else {
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.facilities) { facility in
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
                .padding(.horizontal, 22)
                .padding(.bottom, 24)
            }
        }
    }
    
    private func categoryTitle(_ category: String) -> String {
        switch category {
        case "TOILET":
            return "공공화장실"
        case "SHELTER":
            return "무더위쉼터"
        case "WIFI":
            return "공공와이파이"
        default:
            return "목록"
        }
    }
}

#Preview {
    FacilityListView(initialCategory: "TOILET")
}
