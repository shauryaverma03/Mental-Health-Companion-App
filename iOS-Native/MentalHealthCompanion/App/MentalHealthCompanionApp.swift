import SwiftUI
import FirebaseCore

// Firebase App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MentalHealthCompanionApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var firebaseInitialized = true

    var body: some Scene {
        WindowGroup {
            if firebaseInitialized {
                HeroPageView()
            } else {
                FirebaseErrorView()
            }
        }
    }
}

// MARK: - Firebase Error Screen
struct FirebaseErrorView: View {
    var body: some View {
        ZStack {
            // Background gradient matching the Dart version
            LinearGradient(
                colors: [
                    Color(red: 0.62, green: 0.85, blue: 0.96), // #9ED8F6
                    Color(red: 0.91, green: 0.97, blue: 0.99), // #E8F8FC
                    .white
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(.red)

                Text("Unable to initialize Firebase")
                    .font(.system(size: 18, weight: .bold))

                Text("Check your GoogleService-Info.plist and Firebase configuration, then restart the app.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(radius: 6)
            )
            .padding(.horizontal, 24)
        }
    }
}
