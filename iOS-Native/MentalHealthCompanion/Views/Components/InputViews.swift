import SwiftUI

// MARK: - My TextField (matching my_textfield.dart)
struct MyTextField: View {
    @Binding var text: String
    let hintText: String
    var isSecure: Bool = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(hintText, text: $text)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                TextField(hintText, text: $text)
                    .textFieldStyle(CustomTextFieldStyle())
            }
        }
        .padding(.horizontal, 25)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.15))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Square Tile (matching square_tile.dart)
struct SquareTileView: View {
    let imageName: String
    let text: String

    var body: some View {
        HStack(spacing: 30) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 35)

            Text(text)
                .font(.system(size: 16))
                .padding(10)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white, lineWidth: 1)
                )
        )
        .padding(.horizontal, 25)
    }
}
