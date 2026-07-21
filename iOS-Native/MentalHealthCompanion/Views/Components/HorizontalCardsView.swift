import SwiftUI

// MARK: - Card Item Model
struct CardItem: Identifiable {
    let id = UUID()
    let icon: String // SF Symbol name
    let label: String
    let destination: AnyView
}

// MARK: - Horizontal Cards (matching horizontal_cards.dart)
struct HorizontalCardsView: View {
    let items: [CardItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items) { item in
                    NavigationLink(destination: item.destination) {
                        VStack(spacing: 10) {
                            Image(systemName: item.icon)
                                .font(.system(size: 40))
                                .foregroundColor(.blue.opacity(0.8))

                            Text(item.label)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.blue.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
                        .frame(width: 120, height: 130)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white)
                                .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 150)
    }
}
