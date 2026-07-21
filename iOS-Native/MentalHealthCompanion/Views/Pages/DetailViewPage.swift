import SwiftUI

// MARK: - Detail View Page (matching detail_view.dart)
struct DetailViewPage: View {
    let title: String
    let content: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.system(size: 24, weight: .bold))

            Text(content)
                .font(.system(size: 18))

            Spacer()
        }
        .padding(20)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
