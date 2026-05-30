import SwiftUI

struct CategoryButtonView: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 54, height: 54)
                    
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? color : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack {
        CategoryButtonView(
            title: "공공화장실",
            icon: "drop",
            color: .blue,
            isSelected: true
        ) {}
        
        CategoryButtonView(
            title: "무더위쉼터",
            icon: "mappin.circle",
            color: .green,
            isSelected: false
        ) {}
    }
    .padding()
}
