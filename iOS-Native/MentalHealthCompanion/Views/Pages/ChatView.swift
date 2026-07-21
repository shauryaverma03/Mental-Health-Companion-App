import SwiftUI

// MARK: - Chat Screen (matching chat_screen.dart)
struct ChatView: View {
    @State private var messageText = ""
    @State private var messages: [[String: Any]] = []
    @StateObject private var chatService = ChatService()
    @Environment(\.dismiss) private var dismiss

    private let userId = "901bf4b9-caa5-4376-a0ec-d0d450cfe1e5"

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Messages List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(messages.enumerated()), id: \.offset) { index, message in
                                let sender = message["sender"] as? String ?? "Unknown"
                                let text = message["message"] as? String ?? ""
                                let isMe = sender != "Pepo"

                                MessageBubbleView(sender: sender, text: text, isMe: isMe)
                                    .id(index)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 20)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.count - 1, anchor: .bottom)
                        }
                    }
                }

                // Input Bar
                HStack(spacing: 8) {
                    TextField("Type your message here...", text: $messageText)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(Color.teal, lineWidth: 1)
                        )

                    Button(action: sendMessage) {
                        Text("Send")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(Color.teal.opacity(0.6))
                            )
                    }
                }
                .padding(8)
            }
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await fetchMessages()
        }
    }

    private func fetchMessages() async {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let adjustedDate = Calendar.current.date(byAdding: .hour, value: -10, to: Date()) ?? Date()
        let dateString = dateFormatter.string(from: adjustedDate)

        let fetched = await chatService.getMessages(userId: userId, date: dateString)
        await MainActor.run {
            messages = fetched
        }
    }

    private func sendMessage() {
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !message.isEmpty else { return }
        messageText = ""

        // Add user message
        messages.append([
            "sender": "User",
            "userId": userId,
            "message": message,
            "timestamp": Int(Date().timeIntervalSince1970 * 1000)
        ])

        // Send and get bot response
        Task {
            let response = await chatService.sendMessages(userId: userId, message: message)
            await MainActor.run {
                messages.append([
                    "sender": "Pepo",
                    "message": response,
                    "timestamp": Int(Date().timeIntervalSince1970 * 1000)
                ])
            }
        }
    }
}

// MARK: - Message Bubble (matching MessageBubble widget)
struct MessageBubbleView: View {
    let sender: String
    let text: String
    let isMe: Bool

    var body: some View {
        VStack(alignment: isMe ? .trailing : .leading, spacing: 4) {
            Text(sender)
                .font(.system(size: 12))
                .foregroundColor(.black.opacity(0.54))

            Text(text)
                .font(.system(size: 15))
                .foregroundColor(isMe ? .black : .black.opacity(0.54))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedCornersShape(
                        corners: isMe
                            ? [.topLeft, .bottomLeft, .bottomRight]
                            : [.topRight, .bottomLeft, .bottomRight],
                        radius: 30
                    )
                    .fill(isMe ? Color.teal.opacity(0.3) : .white)
                    .shadow(color: .black.opacity(0.15), radius: 5, y: 2)
                )
        }
        .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
        .padding(.vertical, 5)
    }
}

// MARK: - Custom Rounded Corners Shape
struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
