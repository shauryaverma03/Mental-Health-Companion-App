import SwiftUI

// MARK: - Music Player Page (matching music_player.dart)
struct MusicPlayerView: View {
    @State private var opacityList: [Double]

    private let categories: [[String: Any]] = [
        [
            "title": "Nature",
            "image": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817934/leaf_a5zvcf.jpg",
            "names": ["Nature Walk", "Nature Calls"],
            "songs": [
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818636/nature1_g9oi6l.mp3",
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818624/nature2_qptiix.mp3"
            ],
            "path": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817936/nature_bg_urkvoo.webp"
        ],
        [
            "title": "Instrumental",
            "image": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817934/instrument_fgk11y.jpg",
            "names": ["Violins", "Mix"],
            "songs": [
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818623/instrument1_gcepby.mp3",
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818632/instrument2_gnmche.mp3"
            ],
            "path": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817934/instrument_fgk11y.jpg"
        ],
        [
            "title": "Binaural",
            "image": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817935/bin_eoeoie.png",
            "names": ["3 Hz", "1 Hz"],
            "songs": [
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818630/binaural1_pz5a7q.mp3",
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818623/binaural2_hwdnht.mp3"
            ],
            "path": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817935/binaural_bg_m0ia29.gif"
        ],
        [
            "title": "Artist",
            "image": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817934/art_nhi71m.jpg",
            "names": ["Nature Walk", "Nature Calls"],
            "songs": [
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818620/artist1_itgttb.mp3",
                "https://res.cloudinary.com/duknzh3qe/video/upload/v1727818621/artist2_vrew89.mp3"
            ],
            "path": "https://res.cloudinary.com/duknzh3qe/image/upload/v1727817934/art_nhi71m.jpg"
        ]
    ]

    init() {
        _opacityList = State(initialValue: Array(repeating: 0.0, count: 4))
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.5), Color.teal.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Listen to\ntherapy music ..")
                    .font(.custom("Poppins-Regular", size: 30))
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue.opacity(0.9))
                    .padding(.leading, 5)
                    .padding(.top, 20)

                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 20),
                        GridItem(.flexible(), spacing: 20)
                    ], spacing: 20) {
                        ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                            let songs = category["songs"] as? [String] ?? []
                            let names = category["names"] as? [String] ?? []
                            let randomIndex = Int.random(in: 0..<max(songs.count, 1))

                            NavigationLink(destination: SongPlayerView(
                                songPath: songs.indices.contains(randomIndex) ? songs[randomIndex] : "",
                                songName: names.indices.contains(randomIndex) ? names[randomIndex] : "",
                                catImageURL: category["path"] as? String ?? ""
                            )) {
                                ZStack(alignment: .bottom) {
                                    Color.clear
                                        .overlay(
                                            AsyncImage(url: URL(string: category["image"] as? String ?? "")) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                Color.gray.opacity(0.3)
                                            }
                                        )
                                        .clipped()

                                    // Gradient overlay
                                    LinearGradient(
                                        colors: [.black.opacity(0.6), .clear],
                                        startPoint: .bottom,
                                        endPoint: .top
                                    )

                                    Text(category["title"] as? String ?? "")
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                }
                                .frame(height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(radius: 5)
                                .opacity(opacityList[index])
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.top, 16)
                }
            }
            .padding(8)
        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            animateGridItems()
        }
    }

    private func animateGridItems() {
        for i in 0..<categories.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacityList[i] = 1.0
                }
            }
        }
    }
}
