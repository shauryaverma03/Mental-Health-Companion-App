import SwiftUI

// MARK: - Hero Page (matching hero_page.dart)
struct HeroPageView: View {
    @State private var opacity: Double = 0.0
    @State private var scale: Double = 0.8

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(red: 0.88, green: 0.94, blue: 1.0) // Colors.blue[50]
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Spacer().frame(height: 20)

                    Text("Welcome to Saathi")
                        .font(.system(size: 30))
                        .foregroundColor(.blue.opacity(0.7))

                    Text("Your mental health companion")
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3)) // teal[900]

                    Spacer()

                    // Welcome Image with animation
                    Image("welcome")
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                        .opacity(opacity)
                        .scaleEffect(scale)

                    Spacer()

                    // Get Started Button
                    NavigationLink(destination: LoginView()) {
                        Text("Get Started")
                            .font(.custom("Poppins-Regular", size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 20)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.6))
                            )
                    }
                    .opacity(opacity)
                    .scaleEffect(scale)

                    Spacer().frame(height: 20)
                }
                .padding(.horizontal, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("")
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 3.0)) {
                opacity = 1.0
                scale = 1.0
            }
        }
    }
}
