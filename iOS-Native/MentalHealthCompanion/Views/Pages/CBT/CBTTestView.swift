import SwiftUI

// MARK: - CBT Test Page (matching cbt.dart)
struct CBTTestView: View {
    // PHQ-9 Questions
    private let phqQuestions = [
        "1. Little interest or pleasure in doing things?",
        "2. Feeling down, depressed, or hopeless?",
        "3. Trouble falling or staying asleep, or sleeping too much?",
        "4. Feeling tired or having little energy?",
        "5. Poor appetite or overeating?",
        "6. Feeling bad about yourself or that you are a failure?",
        "7. Trouble concentrating on things?",
        "8. Moving or speaking slowly? Or restless?",
        "9. Thoughts of being better off dead or hurting yourself?"
    ]

    // GAD-7 Questions
    private let gadQuestions = [
        "10. Feeling nervous, anxious or on edge?",
        "11. Not being able to stop or control worrying?",
        "12. Worrying too much about different things?",
        "13. Trouble relaxing?",
        "14. Being so restless that it is hard to sit still?",
        "15. Becoming easily annoyed or irritable?",
        "16. Feeling afraid as if something awful might happen?"
    ]

    // Phobia Questions
    private let phobiaQuestions = [
        "17. Social situations due to fear of being embarrassed?",
        "18. Certain situations because of fear of having a panic attack?",
        "19. Certain situations because of a fear of particular objects?"
    ]

    // Work/Social Questions
    private let workSocialQuestions = [
        "20. WORK/STUDY - Ability to perform tasks at work or study?",
        "21. HOME MANAGEMENT - Self-care and managing household?",
        "22. SOCIAL LEISURE ACTIVITIES - Participation in social events?",
        "23. PRIVATE LEISURE ACTIVITIES - Enjoyment of activities done alone?",
        "24. FAMILY AND RELATIONSHIPS - Forming and maintaining relationships?"
    ]

    @State private var phqAnswers: [String: Double] = [:]
    @State private var gadAnswers: [String: Double] = [:]
    @State private var phobiaAnswers: [String: Double] = [:]
    @State private var workSocialAnswers: [String: Double] = [:]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // PHQ Questions
                ForEach(phqQuestions, id: \.self) { question in
                    questionSlider(question: question, answers: $phqAnswers, maxScale: 3)
                }

                // GAD Questions
                ForEach(gadQuestions, id: \.self) { question in
                    questionSlider(question: question, answers: $gadAnswers, maxScale: 3)
                }

                // Phobia Questions
                ForEach(phobiaQuestions, id: \.self) { question in
                    questionSlider(question: question, answers: $phobiaAnswers, maxScale: 8)
                }

                // Work/Social Questions
                ForEach(workSocialQuestions, id: \.self) { question in
                    questionSlider(question: question, answers: $workSocialAnswers, maxScale: 8)
                }

                Spacer().frame(height: 20)

                // Submit Button
                NavigationLink(destination: CBTResultView(
                    phqTotal: Int(phqAnswers.values.reduce(0, +)),
                    gadTotal: Int(gadAnswers.values.reduce(0, +)),
                    phobiaScores: phobiaQuestions.map { Int(phobiaAnswers[$0] ?? 0) },
                    workSocialTotal: Int(workSocialAnswers.values.reduce(0, +))
                )) {
                    Text("Submit")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue.opacity(0.5))
                        )
                }
            }
            .padding(16)
        }
        .navigationTitle("CBT Test")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Initialize answers
            for q in phqQuestions { phqAnswers[q] = 0 }
            for q in gadQuestions { gadAnswers[q] = 0 }
            for q in phobiaQuestions { phobiaAnswers[q] = 0 }
            for q in workSocialQuestions { workSocialAnswers[q] = 0 }
        }
    }

    private func questionSlider(question: String, answers: Binding<[String: Double]>, maxScale: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(question)
                .font(.system(size: 18))

            HStack {
                Text("0")
                    .font(.caption)
                    .foregroundColor(.gray)

                Slider(
                    value: Binding(
                        get: { answers.wrappedValue[question] ?? 0 },
                        set: { answers.wrappedValue[question] = $0 }
                    ),
                    in: 0...Double(maxScale),
                    step: 1
                )
                .tint(.orange)

                Text("\(maxScale)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 8)

            Text("Selected: \(Int(answers.wrappedValue[question] ?? 0))")
                .font(.caption)
                .foregroundColor(Color.blue.opacity(0.9))

            Divider()
                .padding(.top, 4)
        }
        .padding(.vertical, 4)
    }
}
