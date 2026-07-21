import SwiftUI

// MARK: - CBT Result Page (matching cbt_result.dart)
struct CBTResultView: View {
    let phqTotal: Int
    let gadTotal: Int
    let phobiaScores: [Int]
    let workSocialTotal: Int

    @State private var showingInfoAlert = false
    @State private var alertTitle = ""
    @State private var alertContent = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Test Results")
                    .font(.system(size: 24, weight: .bold))

                Spacer().frame(height: 20)

                // PHQ-9
                Button(action: {
                    showInfo(
                        title: "PHQ-9",
                        content: "The Patient Health Questionnaire (PHQ) is a self-administered version of the PRIME-MD diagnostic instrument for common mental disorders. The PHQ-9 is the depression module, which scores each of the 9 DSM-IV criteria as \"0\" (not at all) to \"3\" (nearly every day)."
                    )
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PHQ-9 Total: \(phqTotal)")
                            .font(.system(size: 18))
                        Text("Severity: \(getPHQSeverity())")
                            .font(.system(size: 18))
                    }
                }
                .buttonStyle(.plain)

                Divider().padding(.vertical, 8)

                // GAD-7
                Button(action: {
                    showInfo(
                        title: "GAD-7",
                        content: "The Generalized Anxiety Disorder-7 (GAD-7) is a brief self-report scale to measure anxiety levels. The GAD-7 assesses symptoms of generalized anxiety disorder and scores them from \"0\" (not at all) to \"3\" (nearly every day)."
                    )
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GAD-7 Total: \(gadTotal)")
                            .font(.system(size: 18))
                        Text("Severity: \(getGADSeverity())")
                            .font(.system(size: 18))
                    }
                }
                .buttonStyle(.plain)

                Divider().padding(.vertical, 8)

                // Phobia
                Button(action: {
                    showInfo(
                        title: "Phobia Assessment",
                        content: "This section assesses common phobias by rating symptoms on a scale from \"0\" (not at all) to \"4\" (extreme fear). Scores help identify potential phobic tendencies."
                    )
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Phobia Assessment")
                            .font(.system(size: 18))
                        Text(getPhobiaAssessment())
                            .font(.system(size: 18))
                    }
                }
                .buttonStyle(.plain)

                Divider().padding(.vertical, 8)

                // Work & Social
                Button(action: {
                    showInfo(
                        title: "Work and Social Adjustment",
                        content: "The Work and Social Adjustment Scale (WSAS) measures how mental health problems affect a person's ability to work and function socially. Higher scores indicate greater impairment in work and social functioning."
                    )
                }) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Work and Social Adjustment Total: \(workSocialTotal)")
                            .font(.system(size: 18))
                        Text("Severity: \(getWorkSocialSeverity())")
                            .font(.system(size: 18))
                    }
                }
                .buttonStyle(.plain)

                Divider().padding(.vertical, 8)

                Spacer().frame(height: 20)

                Text("Important Note: These results are for informational purposes only and are not a diagnostic tool. Please consult a healthcare professional for a proper diagnosis.")
                    .font(.system(size: 14))
                    .foregroundColor(.red.opacity(0.8))
            }
            .padding(16)
        }
        .navigationTitle("CBT Results")
        .navigationBarTitleDisplayMode(.inline)
        .alert(alertTitle, isPresented: $showingInfoAlert) {
            Button("Close", role: .cancel) {}
        } message: {
            Text(alertContent)
        }
    }

    private func showInfo(title: String, content: String) {
        alertTitle = title
        alertContent = content
        showingInfoAlert = true
    }

    private func getPHQSeverity() -> String {
        if phqTotal >= 20 { return "Severe" }
        if phqTotal >= 15 { return "Moderately Severe" }
        if phqTotal >= 10 { return "Moderate" }
        if phqTotal >= 5 { return "Mild" }
        return "None"
    }

    private func getGADSeverity() -> String {
        if gadTotal >= 16 { return "Severe Anxiety" }
        if gadTotal >= 11 { return "Moderate Anxiety" }
        if gadTotal >= 5 { return "Mild Anxiety" }
        return "None"
    }

    private func getPhobiaAssessment() -> String {
        if phobiaScores.contains(where: { $0 >= 4 }) {
            return "Further assessment recommended for possible phobia"
        }
        return "No significant phobia symptoms detected"
    }

    private func getWorkSocialSeverity() -> String {
        if workSocialTotal >= 20 { return "Severe Impairment" }
        if workSocialTotal >= 10 { return "Moderate Impairment" }
        return "Low Impairment"
    }
}
