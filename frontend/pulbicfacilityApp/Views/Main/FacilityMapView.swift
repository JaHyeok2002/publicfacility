import SwiftUI
import MapKit

struct FacilityMapView: View {
    @StateObject private var viewModel = FacilityViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @State private var selectedCategory: String? = nil
    @State private var selectedFacility: Facility?
    
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
            span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        )
    )
    
    // 서울시청 좌표
    private let fallbackCoordinate = CLLocationCoordinate2D(
        latitude: 37.5665,
        longitude: 126.9780
    )
    
    private let categories: [(title: String, code: String?)] = [
        ("전체", nil),
        ("공공화장실", "TOILET"),
        ("무더위쉼터", "SHELTER"),
        ("공공와이파이", "WIFI")
    ]
    
    // 개발/시뮬레이터 테스트용: 항상 서울시청 기준
    private var currentCoordinate: CLLocationCoordinate2D {
        fallbackCoordinate
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $cameraPosition) {
                    Marker(
                        "현재 위치",
                        systemImage: "location.fill",
                        coordinate: currentCoordinate
                    )
                    .tint(.blue)
                    
                    ForEach(viewModel.facilities) { facility in
                        Annotation(
                            facility.name,
                            coordinate: CLLocationCoordinate2D(
                                latitude: facility.latitude,
                                longitude: facility.longitude
                            )
                        ) {
                            Button {
                                selectedFacility = facility
                                moveCamera(to: facility)
                            } label: {
                                Image(systemName: markerIcon(for: facility.category))
                                    .font(.system(size: 34))
                                    .foregroundColor(markerColor(for: facility.category))
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                        }
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                
                VStack(spacing: 0) {
                    filterView
                    
                    Spacer()
                    
                    if let selectedFacility {
                        selectedCard(facility: selectedFacility)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 18)
                    }
                }
            }
            .navigationTitle("지도")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await loadFacilities()
            }
        }
    }
    
    private var filterView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(categories, id: \.title) { category in
                    Button {
                        selectedCategory = category.code
                        selectedFacility = nil
                        
                        Task {
                            await loadFacilities()
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
                            .shadow(color: Color.black.opacity(0.12), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.white.opacity(0.85))
    }
    
    private func selectedCard(facility: Facility) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(facility.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    Text(facility.address)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Button {
                    selectedFacility = nil
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
            }
            
            HStack {
                Text(facility.categoryName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(markerColor(for: facility.category))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(markerColor(for: facility.category).opacity(0.12))
                    .clipShape(Capsule())
                
                if let distance = facility.distance {
                    Text("· \(Int(distance))m")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            NavigationLink {
                FacilityDetailView(facility: facility)
            } label: {
                Text("상세 정보 보기")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(14)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
    }
    
    private func loadFacilities() async {
        let lat = currentCoordinate.latitude
        let lng = currentCoordinate.longitude
        
        if let selectedCategory {
            await viewModel.fetchNearbyByCategory(
                category: selectedCategory,
                lat: lat,
                lng: lng
            )
        } else {
            await viewModel.fetchNearby(lat: lat, lng: lng)
        }
        
        selectedFacility = nil
        
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: lat, longitude: lng),
                span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            )
        )
    }
    
    private func moveCamera(to facility: Facility) {
        cameraPosition = .region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(
                    latitude: facility.latitude,
                    longitude: facility.longitude
                ),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
    }
    
    private func markerColor(for category: String) -> Color {
        switch category {
        case "TOILET":
            return .blue
        case "SHELTER":
            return .green
        case "WIFI":
            return .purple
        default:
            return .blue
        }
    }
    
    private func markerIcon(for category: String) -> String {
        switch category {
        case "TOILET":
            return "drop.circle.fill"
        case "SHELTER":
            return "mappin.circle.fill"
        case "WIFI":
            return "wifi.circle.fill"
        default:
            return "mappin.circle.fill"
        }
    }
}

#Preview {
    FacilityMapView()
}
