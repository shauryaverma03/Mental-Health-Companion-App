import SwiftUI
import AVFoundation

// MARK: - Song Player Page (matching song_player.dart)
struct SongPlayerView: View {
    let songPath: String
    let songName: String
    let catImageURL: String

    @State private var audioPlayer: AVPlayer?
    @State private var isPlaying = false
    @State private var currentPosition: Double = 0
    @State private var totalDuration: Double = 0
    @State private var timeObserver: Any?

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()
                
                // Song Image
                AsyncImage(url: URL(string: catImageURL)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 200, height: 200)
                .clipped()
                .cornerRadius(12)
                .padding(20)

                // Song Title
                Text("Now Playing: \(songName)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.blue.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 16)

                // Slider
                Slider(value: $currentPosition, in: 0...max(totalDuration, 1)) { editing in
                    if !editing {
                        seekTo(currentPosition)
                    }
                }
                .tint(.blue)
                .padding(.horizontal)

                // Time Labels
                HStack {
                    Text(formatDuration(currentPosition))
                        .foregroundColor(.blue)
                    Spacer()
                    Text(formatDuration(totalDuration))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)

                // Play/Pause Button
                Button(action: togglePlayPause) {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)

                Spacer()
            }
        }
        .navigationTitle("Now Playing")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            setupAudioPlayer()
        }
        .onDisappear {
            audioPlayer?.pause()
            if let observer = timeObserver {
                audioPlayer?.removeTimeObserver(observer)
            }
        }
    }

    private func setupAudioPlayer() {
        guard let url = URL(string: songPath) else { return }
        let playerItem = AVPlayerItem(url: url)
        audioPlayer = AVPlayer(playerItem: playerItem)

        // Observe duration
        playerItem.asset.loadValuesAsynchronously(forKeys: ["duration"]) {
            DispatchQueue.main.async {
                let duration = playerItem.asset.duration
                self.totalDuration = CMTimeGetSeconds(duration)
            }
        }

        // Observe position
        timeObserver = audioPlayer?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.5, preferredTimescale: 600),
            queue: .main
        ) { time in
            self.currentPosition = CMTimeGetSeconds(time)
        }
    }

    private func togglePlayPause() {
        if isPlaying {
            audioPlayer?.pause()
        } else {
            audioPlayer?.play()
        }
        isPlaying.toggle()
    }

    private func seekTo(_ seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        audioPlayer?.seek(to: time)
    }

    private func formatDuration(_ seconds: Double) -> String {
        guard !seconds.isNaN && !seconds.isInfinite else { return "00:00" }
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}
