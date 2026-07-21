import SwiftUI

// MARK: - Flash Card (matching cards.dart)
struct FlashCardView: View {
    private let messages = [
        "You are stronger than you think.",
        "Believe in yourself!",
        "You are doing amazing, don't give up!",
        "Every day is a new beginning.",
        "You are loved and appreciated.",
        "Your potential is limitless.",
        "Keep pushing, success is near.",
        "Good things take time, be patient.",
        "You are not alone in this journey.",
    ]

    private let images = ["aurora", "road", "leaf", "trail"]

    @State private var currentIndex: Int = 0
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Text("It's Okay! We got you.")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.top, 20)

                Spacer()

                // Card Stack
                ZStack {
                    ForEach(Array(messages.enumerated().reversed()), id: \.offset) { index, message in
                        if index >= currentIndex && index < currentIndex + 3 {
                            let relativeIndex = index - currentIndex
                            CardView(
                                message: message,
                                imageName: images[index % images.count]
                            )
                            .offset(y: CGFloat(relativeIndex) * 8)
                            .scaleEffect(1.0 - CGFloat(relativeIndex) * 0.05)
                            .opacity(relativeIndex == 0 ? 1.0 : 0.8)
                            .offset(relativeIndex == 0 ? dragOffset : .zero)
                            .gesture(
                                relativeIndex == 0 ?
                                DragGesture()
                                    .onChanged { value in
                                        dragOffset = value.translation
                                    }
                                    .onEnded { value in
                                        if abs(value.translation.width) > 100 {
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                dragOffset = CGSize(
                                                    width: value.translation.width > 0 ? 500 : -500,
                                                    height: 0
                                                )
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                currentIndex = (currentIndex + 1) % messages.count
                                                dragOffset = .zero
                                            }
                                        } else {
                                            withAnimation {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                                : nil
                            )
                        }
                    }
                }
                .frame(height: 450)

                Spacer()
            }
            .padding(12)
        }
        .navigationBarBackButtonHidden(false)
    }
}

// MARK: - Single Card View
struct CardView: View {
    let message: String
    let imageName: String

    var body: some View {
        ZStack {
            Color.clear
                .overlay(
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                )
                .clipped()
                .opacity(0.8)

            Color.black.opacity(0.2)

            Text(message)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, 12)
    }
}
