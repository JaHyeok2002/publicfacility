import SwiftUI

struct InfoRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 44, height: 44)
                .background(iconColor.opacity(0.15))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(content.isEmpty ? "-" : content)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .lineLimit(3)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.07), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    InfoRowView(
        icon: "mappin.circle",
        iconColor: .blue,
        title: "주소",
        content: "서울시 중구 세종대로 110"
    )
    .padding()
}
