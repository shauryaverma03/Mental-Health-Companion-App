import SwiftUI

// MARK: - Meditation Screen (matching meditation.dart)
struct MeditationView: View {
    @State private var duration: Int = 30
    @State private var timeRemaining: Int = 30
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var timer: Timer?
    @State private var showCompletionAlert = false
    @State private var fadeOpacity: Double = 0.0
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 5) {
                // Yoga Icon placeholder (Lottie in Dart)
                Image(systemName: "figure.yoga")
                    .font(.system(size: 80))
                    .foregroundColor(.blue.opacity(0.7))
                    .frame(height: 150)
                    .opacity(fadeOpacity)

                Text("Be Calm and Breathe Slowly")
                    .font(.custom("Poppins-Regular", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue.opacity(0.9))
                    .multilineTextAlignment(.center)

                Text("Duration: \(duration / 60) min \(duration % 60) sec")
                    .font(.system(size: 18))
                    .foregroundColor(.blue.opacity(0.8))

                // Duration Controls
                HStack(spacing: 20) {
                    Button(action: { duration += 30; timeRemaining = duration }) {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                    }
                    Button(action: {
                        if duration > 30 { duration -= 30; timeRemaining = duration }
                    }) {
                        Image(systemName: "minus")
                            .foregroundColor(.blue)
                            .font(.system(size: 24))
                    }
                }

                // Countdown Timer Circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 6)

                    Circle()
                        .trim(from: 0, to: CGFloat(timeRemaining) / CGFloat(duration))
                        .stroke(Color.blue.opacity(0.5), style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 1), value: timeRemaining)

                    Text("\(timeRemaining)")
                        .font(.system(size: 33, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(width: 160, height: 160)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.4))
                )

                Spacer().frame(height: 15)

                // Control Buttons
                VStack(spacing: 15) {
                    HStack(spacing: 10) {
                        meditationButton(title: "Start") {
                            startTimer()
                        }
                        meditationButton(title: "Resume") {
                            resumeTimer()
                        }
                    }
                    HStack(spacing: 10) {
                        meditationButton(title: "Pause") {
                            pauseTimer()
                        }
                        meditationButton(title: "Restart") {
                            startTimer()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Meditate")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation(.easeIn(duration: 2)) {
                fadeOpacity = 1.0
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .alert("Meditation Complete!", isPresented: $showCompletionAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Well done on your meditation!")
        }
    }

    private func meditationButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .frame(width: 150)
                .padding(15)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                )
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timeRemaining = duration
        isRunning = true
        isPaused = false

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isRunning = false
                showCompletionAlert = true
            }
        }
    }

    private func pauseTimer() {
        timer?.invalidate()
        isPaused = true
    }

    private func resumeTimer() {
        guard isPaused else { return }
        isPaused = false
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                isRunning = false
                showCompletionAlert = true
            }
        }
    }
}
