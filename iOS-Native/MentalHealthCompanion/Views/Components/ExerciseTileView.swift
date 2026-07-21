import SwiftUI

// MARK: - Exercise Tile (matching exercise_tile.dart)
struct ExerciseTileView: View {
    let icon: String // SF Symbol name
    let exerciseName: String
    let numberOfExercise: Int
    let color: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                    )

                Text(exerciseName)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)

                Spacer()
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            )
        }
        .buttonStyle(.plain)
        .padding(.bottom, 12)
    }
}
