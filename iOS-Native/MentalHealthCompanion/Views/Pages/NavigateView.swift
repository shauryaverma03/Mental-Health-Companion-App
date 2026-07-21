import SwiftUI

// MARK: - Navigate Page (matching navigate.dart — dev navigation grid)
struct NavigateView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        NavigationLink(destination: MoodView()) {
                            navButton("Mood")
                        }
                        NavigationLink(destination: DashboardView()) {
                            navButton("Dashboard")
                        }
                        NavigationLink(destination: BreathingView()) {
                            navButton("Breathe")
                        }
                    }

                    HStack(spacing: 16) {
                        NavigationLink(destination: TypeSelectionView()) {
                            navButton("Type")
                        }
                        NavigationLink(destination: JournalView()) {
                            navButton("Journal")
                        }
                        NavigationLink(destination: CommunityView()) {
                            navButton("Community")
                        }
                    }

                    HStack(spacing: 16) {
                        NavigationLink(destination: MeditationView()) {
                            navButton("Meditation")
                        }
                        NavigationLink(destination: ChatView()) {
                            navButton("Chat")
                        }
                        NavigationLink(destination: MusicPlayerView()) {
                            navButton("Music")
                        }
                    }

                    HStack(spacing: 16) {
                        NavigationLink(destination: LoginView()) {
                            navButton("Login")
                        }
                        NavigationLink(destination: FlashCardView()) {
                            navButton("Card")
                        }
                        NavigationLink(destination: DisclaimerView()) {
                            navButton("CBT")
                        }
                    }
                }
                .padding(16)
            }
        }
    }

    private func navButton(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 100, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.mint)
                    .shadow(color: AppColors.mint.opacity(0.6), radius: 4, y: 2)
            )
    }
}
