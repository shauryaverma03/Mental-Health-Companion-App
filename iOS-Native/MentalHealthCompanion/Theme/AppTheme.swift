import SwiftUI

// MARK: - App Colors (matching colors.dart)
struct AppColors {
    static let mint = Color(red: 0.62, green: 0.85, blue: 0.96)         // #9ED8F6
    static let mintDark = Color(red: 0.18, green: 0.56, blue: 0.69)     // #2E8FAF
    static let white = Color.white
    static let accent = Color(red: 1.0, green: 0.65, blue: 0.15)        // #FFA726
    static let black = Color.black

    // Gradient used across the app
    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.62, green: 0.85, blue: 0.96), // top — soft sky blue
            Color(red: 0.91, green: 0.97, blue: 0.99), // mid — very light sky tint
            .white                                       // bottom — white
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    // Page-level gradient (blue to teal) used in Dashboard, Breathe, etc.
    static let pageGradient = LinearGradient(
        colors: [
            Color.blue.opacity(0.5),    // Colors.blue[300]
            Color.teal.opacity(0.25)    // Colors.teal[100]
        ],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Custom Font (matching Poppins usage)
extension Font {
    static func poppins(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return .custom("Poppins-Regular", size: size).weight(weight)
    }

    static func poppinsBold(_ size: CGFloat) -> Font {
        return .custom("Poppins-Bold", size: size)
    }
}

// MARK: - View Modifiers
struct GradientBackground: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func gradientBackground() -> some View {
        modifier(GradientBackground())
    }
}
