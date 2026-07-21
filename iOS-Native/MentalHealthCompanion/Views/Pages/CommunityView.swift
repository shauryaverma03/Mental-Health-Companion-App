import SwiftUI

// MARK: - Community Page (matching community.dart)
struct CommunityView: View {
    @State private var postText = ""
    @State private var posts: [[String: Any]] = []
    @State private var errorMessage: String?
    @StateObject private var communityService = CommunityService()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.teal.opacity(0.25), Color.gray.opacity(0.15)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Error Message
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(8)
                }

                // Posts List
                if posts.isEmpty {
                    Spacer()
                    Text("No posts yet. Be the first to contribute!")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 10) {
                            ForEach(Array(posts.enumerated()), id: \.offset) { index, post in
                                NavigationLink(destination: PostDetailsView(post: .constant(post))) {
                                    CommunityPostCard(post: post)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }

                // Input Bar
                HStack(spacing: 8) {
                    TextField("Write a post...", text: $postText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )

                    Button(action: addPost) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                    }
                }
                .padding(12)
            }
        }
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchCommunityMessages()
        }
    }

    private func fetchCommunityMessages() async {
        let fetched = await communityService.getCommunityMessages()
        await MainActor.run {
            posts = fetched
            errorMessage = nil
        }
    }

    private func addPost() {
        let message = postText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }

        Task {
            await communityService.createCommunityMessage(
                userId: "2afca97e-8c6c-4f08-acee-bc9af7489726",
                message: message
            )
            await MainActor.run {
                posts.append([
                    "userId": "Anonymous User",
                    "timestamp": Int(Date().timeIntervalSince1970 * 1000),
                    "message": message,
                    "comments": [] as [[String: Any]]
                ])
                postText = ""
            }
        }
    }
}

// MARK: - Community Post Card
struct CommunityPostCard: View {
    let post: [String: Any]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Anonymous User")
                .font(.system(size: 16, weight: .medium))

            if let timestamp = post["timestamp"] as? Int {
                Text(formatTimestamp(timestamp))
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.6))
            }

            Text(post["message"] as? String ?? "")
                .font(.system(size: 16))
                .foregroundColor(.black.opacity(0.7))
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        )
    }

    private func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}
