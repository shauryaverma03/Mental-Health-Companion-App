import SwiftUI

// MARK: - Challenge Item
struct ChallengeItem: Identifiable {
    let id = UUID()
    let label: String
    let icon: String // SF Symbol
    let gradientColors: [Color]
}

// MARK: - Type Selection Page (matching type.dart)
struct TypeSelectionView: View {
    @State private var selectedItems: Set<Int> = []

    private let items: [ChallengeItem] = [
        ChallengeItem(label: "Anxiety", icon: "face.dashed", gradientColors: [.orange.opacity(0.6), .orange.opacity(0.8)]),
        ChallengeItem(label: "Motivation", icon: "bolt.fill", gradientColors: [.indigo.opacity(0.6), .indigo.opacity(0.8)]),
        ChallengeItem(label: "Confidence", icon: "hand.thumbsup.fill", gradientColors: [.pink.opacity(0.6), .pink.opacity(0.8)]),
        ChallengeItem(label: "Sleep", icon: "moon.stars.fill", gradientColors: [.blue.opacity(0.6), .blue.opacity(0.8)]),
        ChallengeItem(label: "Depression", icon: "face.smiling.inverse", gradientColors: [.purple.opacity(0.6), .purple.opacity(0.8)]),
        ChallengeItem(label: "Work Stress", icon: "briefcase.fill", gradientColors: [.green.opacity(0.6), .green.opacity(0.8)]),
        ChallengeItem(label: "Relationships", icon: "heart.fill", gradientColors: [.yellow.opacity(0.6), .yellow.opacity(0.8)]),
        ChallengeItem(label: "Exam Stress", icon: "graduationcap.fill", gradientColors: [.red.opacity(0.6), .red.opacity(0.8)]),
    ]

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 8) {
                Text("Building your space...")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(.black)

                Text("Add challenges that you would like help with")
                    .font(.system(size: 16))
                    .foregroundColor(.black)

                Spacer().frame(height: 16)

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                            Button(action: {
                                if selectedItems.contains(index) {
                                    selectedItems.remove(index)
                                } else {
                                    selectedItems.insert(index)
                                }
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: 8) {
                                        Image(systemName: item.icon)
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                        Text(item.label)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 24)
                                    .background(
                                        LinearGradient(
                                            colors: item.gradientColors,
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .cornerRadius(20)
                                    .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 3)

                                    if selectedItems.contains(index) {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                            .padding(4)
                                            .background(Circle().fill(.white))
                                            .padding(8)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 64)

            // Proceed FAB
            VStack {
                Spacer()
                NavigationLink(destination: DashboardView()) {
                    HStack(spacing: 5) {
                        Text("Proceed")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.blue)
                    )
                    .padding(.horizontal, 35)
                }
            }
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
    }
}
