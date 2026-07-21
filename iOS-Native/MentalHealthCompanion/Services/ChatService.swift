import Foundation
import Combine
// MARK: - Chat Service (matching chat_service.dart)
class ChatService: ObservableObject {

    private let baseURL = "https://gen-ai-g6tt.onrender.com/api/v1/chat"

    func sendMessages(userId: String, message: String) async -> String {
        guard let url = URL(string: "\(baseURL)/add") else { return "" }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["userId": userId, "message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Failed to send message")
                return ""
            }
            print("Message sent")
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let botResponse = json["botResponse"] as? String {
                return botResponse
            }
            return ""
        } catch {
            print("Error sending messages: \(error)")
            return ""
        }
    }

    func getMessages(userId: String, date: String) async -> [[String: Any]] {
        guard let url = URL(string: "\(baseURL)/get/\(userId)/\(date)") else { return [] }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                print("Failed to get messages")
                return []
            }
            if let messages = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                return messages
            }
            return []
        } catch {
            print("Error getting messages: \(error)")
            return []
        }
    }
}
