import SwiftUI
import AVFoundation

// MARK: - Breathing Screen (matching breathe.dart)
struct BreathingView: View {
    @State private var isStarted = false
    @State private var sliderValue: Double = 0.0
    @State private var timer: Timer?
    @State private var audioPlayer: AVPlayer?
    @Environment(\.dismiss) private var dismiss

    private let maxSliderValue: Double = 1500.0
    private let audioPath = "https://res.cloudinary.com/dksnirztn/video/upload/v1729189988/mixkit-morning-birds-2472_1_ondanv.wav"

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Sound Selection Badge
                HStack {
                    HStack(spacing: 10) {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(.white)
                        Text("Sound: Chirping Birds")
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                    )
                }

                Spacer()

                // Breathing Animation / Start Circle
                if isStarted {
                    // Animated breathing circle
                    BreathingAnimationView()
                        .frame(width: 240, height: 240)
                } else {
                    Circle()
                        .fill(Color(red: 0.05, green: 0.53, blue: 0.73))
                        .frame(width: 240, height: 240)
                        .overlay(
                            Text("Start")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(.white)
                        )
                }

                Spacer()

                // Timer Controls
                VStack(spacing: 0) {
                    Text("05:21")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.43))

                    Slider(value: $sliderValue, in: 0...maxSliderValue)
                        .tint(Color(red: 0.0, green: 0.35, blue: 0.43))
                        .padding(.horizontal)

                    Text("25:00")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.43))

                    Spacer().frame(height: 20)

                    // Control Buttons
                    HStack(spacing: 20) {
                        Button(action: {}) {
                            Image(systemName: "gobackward.10")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 0.08, green: 0.49, blue: 0.61))
                        }

                        if isStarted {
                            Button(action: stopTimer) {
                                Text("Stop")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.43))
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                    )
                            }
                        } else {
                            Button(action: startTimer) {
                                Text("Start")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.43))
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(.white)
                                    )
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .navigationBarBackButtonHidden(false)
        .onDisappear {
            stopTimer()
        }
    }

    private func startTimer() {
        guard !isStarted else { return }
        isStarted = true

        // Play audio
        if let url = URL(string: audioPath) {
            audioPlayer = AVPlayer(url: url)
            audioPlayer?.play()
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if sliderValue < maxSliderValue {
                sliderValue += 1.0
            } else {
                stopTimer()
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        audioPlayer?.pause()
        isStarted = false
    }
}

// MARK: - Breathing Animation
struct BreathingAnimationView: View {
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.6

    var body: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.cyan.opacity(0.6), Color.blue.opacity(0.3)],
                    center: .center,
                    startRadius: 20,
                    endRadius: 120
                )
            )
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 4).repeatForever(autoreverses: true)) {
                    scale = 1.2
                    opacity = 1.0
                }
            }
    }
}
