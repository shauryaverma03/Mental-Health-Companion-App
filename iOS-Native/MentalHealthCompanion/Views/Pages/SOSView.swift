import SwiftUI

// MARK: - SOS Screen (matching sos.dart)
struct SOSView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.teal.opacity(0.05)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    // Call Your Buddy Button
                    Button(action: {}) {
                        HStack(spacing: 8) {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.teal)
                                .font(.system(size: 25))
                            Text("Call your buddy")
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3))
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 5)
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 16)

                    // OR divider
                    HStack {
                        Rectangle()
                            .fill(.white)
                            .frame(height: 2)
                            .padding(.leading, 50)

                        Text("or")
                            .foregroundColor(.white)
                            .fontWeight(.bold)

                        Rectangle()
                            .fill(.white)
                            .frame(height: 2)
                            .padding(.trailing, 50)
                    }

                    Spacer().frame(height: 9)

                    // Emergency Contacts Section
                    VStack(spacing: 16) {
                        Text("Emergency Contacts")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3))

                        CustomSOSButton(
                            text: "Helpline",
                            icon: "phone.fill",
                            color: .blue,
                            action: {}
                        )
                        .padding(.horizontal, 25)

                        CustomSOSButton(
                            text: "Helpline",
                            icon: "questionmark.circle.fill",
                            color: .green,
                            action: {}
                        )
                        .padding(.horizontal, 25)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 9)

                    // Update Buddy Section
                    VStack(spacing: 16) {
                        Text("Update Buddy")
                            .font(.system(size: 25, weight: .medium))
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3))

                        Text("You can update your buddy to keep them informed about your whereabouts.")
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.35))
                            .multilineTextAlignment(.center)

                        CustomSOSButton(
                            text: "Update Buddy",
                            icon: "info.circle.fill",
                            color: .orange,
                            action: {}
                        )
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.white.opacity(0.8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(.white, lineWidth: 2)
                            )
                            .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)

                    Spacer().frame(height: 25)
                }
                .padding(.top, 16)
            }
        }
        .navigationTitle("SOS")
        .navigationBarTitleDisplayMode(.inline)
    }
}
