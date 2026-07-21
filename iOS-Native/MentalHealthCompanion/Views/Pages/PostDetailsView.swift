import SwiftUI

// MARK: - Post Details Page (matching post_details.dart)
struct PostDetailsView: View {
    @Binding var post: [String: Any]
    @State private var commentText = ""

    var body: some View {
        VStack(spacing: 0) {
            // Post Header
            VStack(alignment: .leading, spacing: 4) {
                Spacer().frame(height: 10)

                Text("Anonymous User")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black.opacity(0.87))

                if let timestamp = post["timestamp"] as? Int {
                    Text(formatTimestamp(timestamp))
                        .font(.system(size: 14))
                        .foregroundColor(.black.opacity(0.54))
                }

                Spacer().frame(height: 12)

                Text(post["message"] as? String ?? "No Content")
                    .font(.system(size: 16))
                    .foregroundColor(.black.opacity(0.87))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(Color.teal.opacity(0.05))
            .overlay(
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3)),
                alignment: .bottom
            )

            // Comments Header
            Text("Comments")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(8)

            // Comments List
            let comments = post["comments"] as? [[String: Any]] ?? []
            ScrollView {
                LazyVStack(spacing: 5) {
                    ForEach(Array(comments.enumerated()), id: \.offset) { _, comment in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(Color.teal.opacity(0.2))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text("A")
                                        .font(.system(size: 16))
                                )

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Anonymous User")
                                    .font(.system(size: 16, weight: .bold))

                                if let ts = comment["timestamp"] as? Int {
                                    Text(formatTimestamp(ts))
                                        .font(.system(size: 12))
                                        .foregroundColor(.black.opacity(0.54))
                                }

                                Text(comment["comment"] as? String ?? "")
                                    .font(.system(size: 14))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 2, y: 1)
                        )
                        .padding(.horizontal, 10)
                    }
                }
            }

            // Comment Input
            HStack(spacing: 8) {
                TextField("Write a comment...", text: $commentText)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )

                Button(action: addComment) {
                    Text("Post")
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.7))
                        )
                        .foregroundColor(.white)
                }
            }
            .padding(8)
        }
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addComment() {
        guard !commentText.isEmpty else { return }
        var comments = post["comments"] as? [[String: Any]] ?? []
        comments.append([
            "userId": "Anonymous",
            "timestamp": Int(Date().timeIntervalSince1970 * 1000),
            "comment": commentText
        ])
        post["comments"] = comments
        commentText = ""
    }

    private func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp) / 1000.0)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        return formatter.string(from: date)
    }
}
