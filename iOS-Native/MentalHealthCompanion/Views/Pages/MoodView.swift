import SwiftUI

// MARK: - Mood Screen (matching mood.dart)
struct MoodView: View {
    @State private var currentValue: Double = 3.0
    @Environment(\.dismiss) private var dismiss

    private let moodOptions: [(label: String, emoji: String, value: Double)] = [
        ("Excellent", "😊", 5),
        ("Good", "😀", 4),
        ("Fair", "😐", 3),
        ("Poor", "😟", 2),
        ("Worst", "😫", 1),
    ]

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.96, blue: 0.95) // #F8F4F3
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("How are you feeling today?")
                    .font(.system(size: 28, weight: .bold))
                    .padding(.top, 16)

                Spacer().frame(height: 40)

                HStack(spacing: 20) {
                    // Mood labels with emojis
                    VStack(spacing: 20) {
                        ForEach(moodOptions, id: \.value) { mood in
                            Button(action: {
                                withAnimation {
                                    currentValue = mood.value
                                }
                            }) {
                                HStack(spacing: 10) {
                                    Text(mood.emoji)
                                        .font(.system(size: 50))
                                        .opacity(currentValue == mood.value ? 1.0 : 0.3)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Spacer()

                    // Vertical Slider (rotated)
                    VStack {
                        Slider(value: $currentValue, in: 1...5, step: 1)
                            .tint(.orange)
                            .rotationEffect(.degrees(-90))
                            .frame(width: 300, height: 50)
                    }
                    .frame(width: 60, height: 350)
                }

                Spacer()
            }
            .padding(16)
        }
        .navigationTitle("Assessment")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
    }
}
