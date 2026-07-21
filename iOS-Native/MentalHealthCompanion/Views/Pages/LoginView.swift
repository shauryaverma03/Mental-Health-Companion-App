import SwiftUI

// MARK: - Login Page (matching login.dart)
struct LoginView: View {
    @State private var nameText: String = ""

    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 50)

                    // Otter Swim GIF/Image
                    Image("otter-swim")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 240)
                        .clipped()

                    Spacer().frame(height: 50)

                    Text("What should we call you?")
                        .font(.system(size: 22))

                    Spacer().frame(height: 25)

                    // Name Textfield
                    MyTextField(text: $nameText, hintText: "captain")

                    Spacer().frame(height: 10)

                    // Pick a cool name text
                    HStack {
                        Spacer()
                        Text("Pick a cool name!")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 25)

                    Spacer().frame(height: 25)

                    // Continue Button
                    NavigationLink(destination: TypeSelectionView()) {
                        Text("Continue")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(25)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.8))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue.opacity(0.9), lineWidth: 2)
                                    )
                            )
                    }
                    .padding(.horizontal, 25)

                    Spacer().frame(height: 50)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}
