import SwiftUI
import MapKit

struct FacilityDetailView: View {
    let facility: Facility
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = FacilityViewModel()
    @State private var detailFacility: Facility?
    
    private var currentFacility: Facility {
        detailFacility ?? facility
    }
    
    private var categoryColor: Color {
        switch currentFacility.category {
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                topMapHeader
                
                VStack(alignment: .leading, spacing: 18) {
                    titleSection
                    
                    infoSection
                    
                    amenitiesSection
                    
                    mapButton
                }
                .padding(.horizontal, 22)
                .padding(.top, 24)
                .padding(.bottom, 36)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            detailFacility = await viewModel.fetchDetail(facilityId: facility.id)
        }
    }
    
    private var topMapHeader: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [
                    categoryColor.opacity(0.18),
                    Color.green.opacity(0.12)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 230)
            
            VStack {
                Spacer()
                
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 74))
                    .foregroundColor(categoryColor)
                    .shadow(color: categoryColor.opacity(0.3), radius: 8, x: 0, y: 4)
                
                Spacer()
            }
            .frame(height: 230)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Button {
                    Task {
                        await viewModel.toggleFavorite(facility: currentFacility)
                    }
                } label: {
                    Image(systemName: currentFacility.favorite ? "heart.fill" : "heart")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(currentFacility.favorite ? .red : .gray)
                        .frame(width: 42, height: 42)
                        .background(Color.white.opacity(0.9))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 52)
        }
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(currentFacility.name)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            HStack(spacing: 8) {
                Text(currentFacility.categoryName)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(categoryColor.opacity(0.12))
                    .clipShape(Capsule())
                
                if let distance = currentFacility.distance {
                    Label("\(Int(distance))m", systemImage: "location")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    private var infoSection: some View {
        VStack(spacing: 12) {
            InfoRowView(
                icon: "mappin.circle",
                iconColor: .blue,
                title: "주소",
                content: currentFacility.address
            )
            
            InfoRowView(
                icon: "clock",
                iconColor: .green,
                title: "운영시간",
                content: currentFacility.openTime
            )
            
            InfoRowView(
                icon: "phone",
                iconColor: .purple,
                title: "연락처",
                content: currentFacility.phone
            )
        }
    }
    
    private var amenitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("편의시설")
                .font(.headline)
                .fontWeight(.bold)
            
            if currentFacility.amenities.isEmpty {
                InfoRowView(
                    icon: "info.circle",
                    iconColor: .orange,
                    title: "편의시설",
                    content: "제공된 정보가 없습니다."
                )
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(currentFacility.amenities, id: \.self) { amenity in
                        HStack(spacing: 10) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(categoryColor)
                            
                            Text(amenity)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(18)
                .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 2)
            }
        }
    }
    
    private var mapButton: some View {
        Button {
            openInAppleMaps()
        } label: {
            Label("지도에서 보기", systemImage: "map")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(14)
        }
        .padding(.top, 8)
    }
    
    private func openInAppleMaps() {
        let coordinate = CLLocationCoordinate2D(
            latitude: currentFacility.latitude,
            longitude: currentFacility.longitude
        )
        
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = currentFacility.name
        mapItem.openInMaps()
    }
}

#Preview {
    NavigationStack {
        FacilityDetailView(
            facility: Facility(
                id: 1,
                name: "서울시청 공중화장실",
                category: "TOILET",
                categoryName: "공공화장실",
                address: "서울시 중구 세종대로 110",
                latitude: 37.5665,
                longitude: 126.9780,
                distance: 120,
                openTime: "24시간 운영",
                phone: "02-120",
                amenities: ["남성 화장실 수: 2", "여성 화장실 수: 2", "비상벨 설치 여부: Y"],
                favorite: false
            )
        )
    }
}
