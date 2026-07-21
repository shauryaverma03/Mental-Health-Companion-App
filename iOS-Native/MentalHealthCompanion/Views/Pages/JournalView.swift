import SwiftUI

// MARK: - Journal Page (matching journal.dart)
struct JournalView: View {
    @State private var journalText = ""
    @Environment(\.dismiss) private var dismiss

    private let data: [(timeStamp: String, title: String, content: String)] = [
        ("2/8", "Therapy Session",
         "Discussed coping mechanisms for anxiety and stress management techniques."),
        ("11/07", "Mindfulness Practice",
         "Practiced mindfulness meditation for 30 minutes. Felt more relaxed and centered afterwards."),
        ("23/06", "Support Group Meeting",
         "Attended a support group meeting. Shared experiences and received encouragement from others."),
    ]

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 20)

                    // Journal Input
                    TextEditor(text: $journalText)
                        .frame(height: 120)
                        .padding(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.teal.opacity(0.6), lineWidth: 1)
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.teal.opacity(0.05))
                        )

                    Spacer().frame(height: 30)

                    // Submit Button
                    Button(action: {}) {
                        HStack {
                            Text("Submit")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 25)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.teal)
                        )
                    }

                    Spacer().frame(height: 20)

                    // Journal Cards
                    ForEach(Array(data.enumerated()), id: \.offset) { index, entry in
                        JournalCardRow(
                            index: index,
                            time: entry.timeStamp,
                            title: entry.title,
                            content: entry.content
                        )
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Journal")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Journal Card Row (matching CardRow widget)
struct JournalCardRow: View {
    let index: Int
    let time: String
    let title: String
    let content: String

    var body: some View {
        HStack(spacing: 0) {
            if index % 2 == 0 {
                // Time card first
                timeCard
                    .frame(maxWidth: .infinity, alignment: .center)
                    .layoutPriority(0.3)

                // Content card
                NavigationLink(destination: DetailViewPage(title: title, content: content)) {
                    contentCard
                }
                .buttonStyle(.plain)
                .layoutPriority(0.7)
            } else {
                // Content card first
                NavigationLink(destination: DetailViewPage(title: title, content: content)) {
                    contentCard
                }
                .buttonStyle(.plain)
                .layoutPriority(0.7)

                // Time card
                timeCard
                    .frame(maxWidth: .infinity, alignment: .center)
                    .layoutPriority(0.3)
            }
        }
    }

    private var timeCard: some View {
        Text(time)
            .font(.system(size: 16))
            .padding(15)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
            )
            .padding(10)
    }

    private var contentCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
            Text(content)
                .font(.system(size: 16))
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.white)
                .shadow(color: .black.opacity(0.1), radius: 2, y: 1)
        )
        .padding(10)
    }
}
