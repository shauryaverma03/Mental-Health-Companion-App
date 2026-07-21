import SwiftUI

// MARK: - Dashboard Page (matching dashboard.dart)
struct DashboardView: View {
    @State private var selectedIndex = 0

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            // Tab Content
            TabView(selection: $selectedIndex) {
                DashboardContentView()
                    .tag(0)

                CommunityView()
                    .tag(1)

                FlashCardView()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Custom Bottom Nav Bar
            VStack {
                Spacer()
                CustomBottomNavBar(selectedIndex: $selectedIndex)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Dashboard Content (main home tab)
struct DashboardContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section
                VStack(spacing: 0) {
                    // Hello + SOS row
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Hello Shaurya!")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(Color.blue.opacity(0.9))
                        }
                        Spacer()
                        NavigationLink(destination: SOSView()) {
                            Image(systemName: "sos")
                                .foregroundColor(.white)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.orange.opacity(0.8))
                                )
                        }
                    }

                    Spacer().frame(height: 25)

                    // Journal + Mood pills
                    HStack {
                        NavigationLink(destination: JournalView()) {
                            HStack(spacing: 8) {
                                Image(systemName: "sun.max.fill")
                                    .foregroundColor(.blue)
                                Text("Journal")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .overlay(Capsule().stroke(Color.blue.opacity(0.8), lineWidth: 2))
                            )
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        NavigationLink(destination: MoodView()) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.blue)
                                Text("Mood")
                                    .font(.system(size: 20))
                                    .foregroundColor(.blue)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(
                                Capsule()
                                    .fill(.white)
                                    .overlay(Capsule().stroke(Color.blue.opacity(0.8), lineWidth: 2))
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer().frame(height: 25)

                    // Panda chat section
                    HStack(spacing: 10) {
                        Image("otter")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 90)
                            .clipped()

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Panda loves to talk!")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(Color.blue.opacity(0.9))
                                .padding(.leading, 18)

                            NavigationLink(destination: ChatView()) {
                                HStack {
                                    Text("Chat with Panda")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 24))
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    Capsule()
                                        .fill(Color.blue.opacity(0.8))
                                        .overlay(Capsule().stroke(Color.blue.opacity(0.3), lineWidth: 2))
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(25)

                Spacer().frame(height: 25)

                // Looking for something section
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Looking for something?")
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Image(systemName: "ellipsis")
                    }

                    HorizontalCardsView(items: [
                        CardItem(icon: "figure.mind.and.body", label: "Meditate",
                                 destination: AnyView(MeditationView())),
                        CardItem(icon: "music.note", label: "Music",
                                 destination: AnyView(MusicPlayerView())),
                        CardItem(icon: "wind", label: "Breathe",
                                 destination: AnyView(BreathingView())),
                        CardItem(icon: "book.fill", label: "CBT",
                                 destination: AnyView(DisclaimerView())),
                    ])

                    Text("Explore")
                        .font(.system(size: 20, weight: .bold))

                    // Explore tiles
                    ExerciseTileView(
                        icon: "heart.fill",
                        exerciseName: "Blogs",
                        numberOfExercise: 16,
                        color: .orange,
                        onTap: { }
                    )
                    .background(
                        NavigationLink(destination: BlogView()) {
                            EmptyView()
                        }
                        .opacity(0)
                    )

                    ExerciseTileView(
                        icon: "person.fill",
                        exerciseName: "Contact Professionals",
                        numberOfExercise: 8,
                        color: .green,
                        onTap: { }
                    )
                    .background(
                        NavigationLink(destination: ContactProfessionalsView()) {
                            EmptyView()
                        }
                        .opacity(0)
                    )
                }
                .padding(25)
            }
            .padding(.bottom, 100) // Space for bottom nav
        }
    }
}

// MARK: - Custom Bottom Nav Bar (matching CustomBottomNavBar)
struct CustomBottomNavBar: View {
    @Binding var selectedIndex: Int

    var body: some View {
        HStack {
            Spacer()
            navButton(icon: "house.fill", index: 0)
            Spacer()
            navButton(icon: "bubble.left.fill", index: 1)
            Spacer()
            navButton(icon: "chart.bar.fill", index: 2)
            Spacer()
        }
        .frame(height: 80)
        .background(
            RoundedRectangle(cornerRadius: 40)
                .fill(.white)
        )
    }

    private func navButton(icon: String, index: Int) -> some View {
        Button(action: {
            selectedIndex = index
        }) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(selectedIndex == index ? .black : .gray)
        }
    }
}
