import SwiftUI

struct FacilityCardView: View {
    let facility: Facility
    var onFavoriteTap: (() -> Void)?
    var onCardTap: (() -> Void)?
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                onCardTap?()
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
                onFavoriteTap?()
            } label: {
                Image(systemName: facility.favorite ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(facility.favorite ? .red : .gray)
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
    FacilityCardView(
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
            amenities: ["남성 화장실 수: 2"],
            favorite: false
        ),
        onFavoriteTap: {},
        onCardTap: {}
    )
    .padding()
}
