import SwiftUI

// MARK: - Blog Article Model
struct BlogArticle: Identifiable {
    let id = UUID()
    let articleTitle: String
    let articleImage: String
    let articleDetails: String
}

// MARK: - Blog Screen (matching blog.dart)
struct BlogView: View {
    private let articles: [BlogArticle] = [
        BlogArticle(
            articleTitle: "The Importance of Sleep",
            articleImage: "sleep",
            articleDetails: "Sleep is essential for overall well-being, playing a critical role in physical and mental health. During sleep, the body repairs tissues, strengthens the immune system, and restores energy levels, which are vital for maintaining optimal physical performance and preventing illness. Sleep also supports cognitive functions, such as memory consolidation, learning, and emotional regulation, allowing the brain to process information and manage stress effectively. Consistent, quality sleep enhances problem-solving abilities, creativity, and decision-making, while reducing the risk of mental health issues like anxiety and depression. Lack of sleep impairs attention, reaction times, and judgment, increasing the likelihood of accidents and poor performance in daily tasks. Additionally, insufficient sleep is linked to chronic conditions such as obesity, diabetes, and heart disease, making it crucial for long-term health. Cultivating healthy sleep habits improves mood, productivity, and overall quality of life."
        ),
        BlogArticle(
            articleTitle: "Depression: Silent Killer",
            articleImage: "depression",
            articleDetails: "Depression is a mood disorder that causes a persistent feeling of sadness and loss of interest. Also called major depressive disorder or clinical depression, it affects how you feel, think and behave and can lead to a variety of emotional and physical problems."
        ),
        BlogArticle(
            articleTitle: "Anxiety: The Fear Within",
            articleImage: "anxiety",
            articleDetails: "Anxiety is your body's natural response to stress. It's a feeling of fear or apprehension about what's to come. The first day of school, going to a job interview, or giving a speech may cause most people to feel fearful and nervous."
        ),
    ]

    var body: some View {
        ZStack {
            AppColors.pageGradient
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer().frame(height: 20)

                    Text("All Articles")
                        .font(.system(size: 18, weight: .bold))

                    Spacer().frame(height: 16)

                    ForEach(articles) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            ArticleCardView(article: article)
                        }
                        .buttonStyle(.plain)
                        .padding(.bottom, 16)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationTitle("Blogs")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Article Card (matching ArticleCard)
struct ArticleCardView: View {
    let article: BlogArticle

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(article.articleImage)
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()

            Text(article.articleTitle)
                .font(.system(size: 18, weight: .bold))
                .padding(8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Article Detail View (matching ArticleDetailScreen)
struct ArticleDetailView: View {
    let article: BlogArticle

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.teal.opacity(0.25), Color.teal.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Image(article.articleImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipped()
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)

                    VStack(alignment: .leading, spacing: 10) {
                        Text(article.articleTitle)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(red: 0.0, green: 0.3, blue: 0.3))

                        Divider()
                            .background(Color.teal.opacity(0.3))

                        Text(article.articleDetails)
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.0, green: 0.35, blue: 0.35))
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .shadow(radius: 5)
                    )
                }
                .padding(16)
            }
        }
        .navigationTitle(article.articleTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}
