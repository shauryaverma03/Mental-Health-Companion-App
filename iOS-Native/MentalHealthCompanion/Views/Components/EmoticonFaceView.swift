import SwiftUI

// MARK: - Emoticon Face (matching emoticon_face.dart)
struct EmoticonFaceView: View {
    let emoticonFace: String

    var body: some View {
        Text(emoticonFace)
            .font(.system(size: 28))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.teal.opacity(0.2))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.teal, lineWidth: 2)
                    )
            )
    }
}

// MARK: - Emoticon Faces Component (matching emoticon_faces.dart)
struct EmoticonFacesComponent: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("How do you feel?")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(red: 0.0, green: 0.47, blue: 0.45)) // teal[600]
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.white)
            }

            Spacer().frame(height: 25)

            HStack(spacing: 16) {
                moodColumn(emoji: "😫", label: "Bad")
                moodColumn(emoji: "😀", label: "Fine")
                moodColumn(emoji: "😆", label: "Well")
                moodColumn(emoji: "😊", label: "Excellent")
            }
        }
    }

    private func moodColumn(emoji: String, label: String) -> some View {
        VStack(spacing: 8) {
            EmoticonFaceView(emoticonFace: emoji)
                .frame(width: 60, height: 60)
            Text(label)
                .foregroundColor(.teal)
                .font(.system(size: 14))
        }
    }
}
