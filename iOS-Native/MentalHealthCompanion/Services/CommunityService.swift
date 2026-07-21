import Foundation
import Combine
// MARK: - Community Service (matching community_service.dart)
class CommunityService: ObservableObject {

    private let baseURL = "https://gen-ai-g6tt.onrender.com/api/v1/community"

    func createCommunityMessage(userId: String, message: String) async {
        guard let url = URL(string: "\(baseURL)/create") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["userId": userId, "message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Message created")
            } else {
                print("Failed to create message")
            }
        } catch {
            print("Error creating messages: \(error)")
        }
    }

    func addComment(userId: String, comment: String) async {
        guard let url = URL(string: "\(baseURL)/addComment/\(userId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["userId": userId, "comment": comment]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Comment sent")
            } else {
                print("Failed to send comment")
            }
        } catch {
            print("Error sending comment: \(error)")
        }
    }

    func getCommunityMessages() async -> [[String: Any]] {
        guard let url = URL(string: "\(baseURL)/get") else { return [] }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
               let messages = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                print("Got messages")
                return messages
            }
            print("Failed to get message")
            return []
        } catch {
            print("Error getting messages: \(error)")
            return []
        }
    }

    func getCommunityMessagesById(userId: String) async -> [[String: Any]] {
        guard let url = URL(string: "\(baseURL)/get/\(userId)") else { return [] }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200,
               let messages = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                print("Got messages")
                return messages
            }
            print("Failed to get message")
            return []
        } catch {
            print("Error getting messages: \(error)")
            return []
        }
    }
}
