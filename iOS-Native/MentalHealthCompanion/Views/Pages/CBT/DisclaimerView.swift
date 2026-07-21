import SwiftUI

// MARK: - CBT Disclaimer Page (matching disclaimer.dart)
struct DisclaimerView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Spacer()

            Text("Welcome to the CBT Test")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.blue.opacity(0.95))

            Text("This test helps to assess your emotional and mental well-being through a series of questions. Please answer honestly, as the results will be used to provide personalized support.")
                .font(.system(size: 18))
                .foregroundColor(Color.blue.opacity(0.85))

            Text("Remember, there are no right or wrong answers. Just reflect on how you feel.")
                .font(.system(size: 18))
                .foregroundColor(Color.blue.opacity(0.85))

            Spacer().frame(height: 20)

            NavigationLink(destination: CBTTestView()) {
                Text("Start Test")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color.blue.opacity(0.95))
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue.opacity(0.1))
                    )
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            )

            Spacer()
        }
        .padding(16)
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("CBT Test Introduction")
        .navigationBarTitleDisplayMode(.inline)
    }
}
