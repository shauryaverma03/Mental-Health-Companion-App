import SwiftUI

// MARK: - Doctor Data Model
struct DoctorProfile: Identifiable {
    let id = UUID()
    let doctorName: String
    let doctorImage: String
    let doctorSpecialization: String
    let doctorExperience: String
    let doctorRating: Double
    let doctorRatingCount: Int
    let doctorRatingPercentage: Double
}

// MARK: - Contact Professionals (matching contact_professionals.dart)
struct ContactProfessionalsView: View {
    private let doctors: [DoctorProfile] = [
        DoctorProfile(doctorName: "Dr. Elena Gray", doctorImage: "doctor", doctorSpecialization: "Anxiety Expert", doctorExperience: "50m", doctorRating: 4.5, doctorRatingCount: 1200, doctorRatingPercentage: 99.57),
        DoctorProfile(doctorName: "Dr. Phos Gray", doctorImage: "doctor", doctorSpecialization: "Anxiety Expert", doctorExperience: "50m", doctorRating: 4.5, doctorRatingCount: 1200, doctorRatingPercentage: 99.57),
        DoctorProfile(doctorName: "Dr. Elena Gray", doctorImage: "doctor", doctorSpecialization: "Anxiety Expert", doctorExperience: "50m", doctorRating: 4.5, doctorRatingCount: 1200, doctorRatingPercentage: 99.57),
        DoctorProfile(doctorName: "Dr. Phos Gray", doctorImage: "doctor", doctorSpecialization: "Anxiety Expert", doctorExperience: "50m", doctorRating: 4.5, doctorRatingCount: 1200, doctorRatingPercentage: 99.57),
        DoctorProfile(doctorName: "Dr. Phos Gray", doctorImage: "doctor", doctorSpecialization: "Anxiety Expert", doctorExperience: "50m", doctorRating: 4.5, doctorRatingCount: 1200, doctorRatingPercentage: 99.57),
    ]

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(doctors) { doctor in
                        DoctorProfileCardView(doctor: doctor)
                    }
                }
            }
        }
        .navigationTitle("Contact Professionals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Doctor Profile Card (matching DoctorProfileCard)
struct DoctorProfileCardView: View {
    let doctor: DoctorProfile

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Avatar
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(doctor.doctorImage)
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                    )

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(doctor.doctorName)
                            .font(.system(size: 18, weight: .bold))
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.orange)
                            .font(.system(size: 16))
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "brain.head.profile")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text(doctor.doctorSpecialization)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)

                        Spacer().frame(width: 8)

                        Image(systemName: "clock")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        Text(doctor.doctorExperience)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 16))
                    Text("4.5")
                        .font(.system(size: 16))
                        .foregroundColor(.gray.opacity(0.8))
                    Text("(1.2k)")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }

                Spacer()

                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "phone.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                        Text("Contact")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.48, green: 0.29, blue: 1.0)) // #7A49FF
                    )
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.9))
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
    }
}
