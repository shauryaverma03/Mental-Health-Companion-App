import SwiftUI

// MARK: - Goals Screen (matching goals.dart)
struct GoalsView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Start a New Challenge")
                .font(.system(size: 25, weight: .bold))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 15)
                .padding(.bottom, 20)
                .padding(.top, 10)

            // Get Fit
            NavigationLink(destination: GetFitView()) {
                GoalRow(
                    imageURL: "https://static.vecteezy.com/system/resources/previews/004/191/267/original/exercise-color-icon-man-workout-gym-activity-athlete-with-dumbell-training-and-bodybuilding-personal-coach-healthcare-physical-wellness-person-stretching-isolated-illustration-vector.jpg",
                    title: "Get Fit"
                )
            }
            .buttonStyle(.plain)

            // Better Sleep
            NavigationLink(destination: BetterSleepView()) {
                GoalRow(imageName: "sleep", title: "Better Sleep")
            }
            .buttonStyle(.plain)

            // Live Healthier
            NavigationLink(destination: LiveHealthierView()) {
                GoalRow(imageName: "live", title: "Live Healthier")
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Goal Row
struct GoalRow: View {
    var imageName: String? = nil
    var imageURL: String? = nil
    let title: String

    var body: some View {
        HStack {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            } else if let imageURL = imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }

            Text(title)
                .font(.system(size: 20, weight: .bold))

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.black, lineWidth: 1)
        )
        .padding(10)
    }
}

// MARK: - Get Fit View
struct GetFitView: View {
    var body: some View {
        ScrollView {
            Text("1. Set clear goals for what you want to achieve and create a plan to help you get there. Consider factors such as your fitness level, time available, and any equipment you may need.\n\n2. Choose activities that you find enjoyable, such as jogging, swimming, cycling or weightlifting. This will help you stay motivated and make it easier to stick to your fitness routine.")
                .font(.system(size: 25))
                .padding(30)
        }
        .navigationTitle("Get Fit")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Better Sleep View
struct BetterSleepView: View {
    var body: some View {
        ScrollView {
            Text("1. Try to go to bed and wake up at the same time every day, even on weekends. This helps regulate your body's internal clock and can improve the quality of your sleep.\n\n2. Create a relaxing bedtime routine to help signal to your body that it's time to sleep. This might include taking a warm bath, reading a book, or practicing meditation or yoga.")
                .font(.system(size: 25))
                .padding(30)
        }
        .navigationTitle("Better Sleep")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Live Healthier View
struct LiveHealthierView: View {
    var body: some View {
        ScrollView {
            Text("1. Exercise can improve your physical health, mental health, and mood. Aim to exercise for at least 30 minutes a day, five days a week.\n\n2. Make sure you are eating plenty of fruits, vegetables, whole grains, lean proteins, and healthy fats. Avoid processed and junk foods as much as possible.")
                .font(.system(size: 25))
                .padding(30)
        }
        .navigationTitle("Live Healthier")
        .navigationBarTitleDisplayMode(.inline)
    }
}
