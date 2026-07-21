import SwiftUI

// MARK: - Basic Button (matching basic_button.dart / widgets)
struct BasicButtonView: View {
    let text: String
    let action: () -> Void
    var backgroundColor: Color?
    var foregroundColor: Color?
    var width: CGFloat = 100
    var height: CGFloat = 50
    var borderRadius: CGFloat = 12

    var body: some View {
        VStack(spacing: 16) {
            Button(action: action) {
                Text(text)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(foregroundColor ?? .white)
                    .frame(width: width, height: height)
                    .background(
                        RoundedRectangle(cornerRadius: borderRadius)
                            .fill(backgroundColor ?? AppColors.mint)
                            .shadow(color: (backgroundColor ?? AppColors.mint).opacity(0.6), radius: 4, y: 2)
                    )
            }
        }
    }
}

// MARK: - My Button (matching my_button.dart)
struct MyButton: View {
    let text: String
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(text)
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
    }
}

// MARK: - Custom SOS Button (matching custom_sos_container.dart)
struct CustomSOSButton: View {
    let text: String
    let icon: String? // SF Symbol name
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                Text(text)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )
        }
    }
}
