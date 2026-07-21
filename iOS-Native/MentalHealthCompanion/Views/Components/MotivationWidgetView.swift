import SwiftUI

// MARK: - Motivation Widget (matching motivation_widget.dart)
struct MotivationWidgetView: View {
    @State private var quote: String? = nil

    var body: some View {
        VStack {
            Spacer().frame(height: 10)

            if let quote = quote {
                Text(quote)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .frame(height: 100)
                    .padding(8)
            } else {
                ProgressView()
                    .frame(height: 100)
            }
        }
        .task {
            await fetchQuote()
        }
    }

    private func fetchQuote() async {
        let quoteId = Int.random(in: 1...30)
        guard let url = URL(string: "https://dummyjson.com/quotes/\(quoteId)") else { return }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let fetchedQuote = json["quote"] as? String {
                await MainActor.run {
                    self.quote = fetchedQuote
                }
            }
        } catch {
            print("Failed to fetch quote: \(error)")
        }
    }
}
