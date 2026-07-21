import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class BlogScreen extends StatelessWidget {
  final Object data = ([
    {
      'articleTitle': 'The Importance of Sleep',
      'articleImage': 'assets/images/sleep.jpg',
      'articleDetails':
          'Sleep is essential for overall well-being, playing a critical role in physical and mental health. During sleep, the body repairs tissues, strengthens the immune system, and restores energy levels, which are vital for maintaining optimal physical performance and preventing illness. Sleep also supports cognitive functions, such as memory consolidation, learning, and emotional regulation, allowing the brain to process information and manage stress effectively. Consistent, quality sleep enhances problem-solving abilities, creativity, and decision-making, while reducing the risk of mental health issues like anxiety and depression. Lack of sleep impairs attention, reaction times, and judgment, increasing the likelihood of accidents and poor performance in daily tasks. Additionally, insufficient sleep is linked to chronic conditions such as obesity, diabetes, and heart disease, making it crucial for long-term health. Cultivating healthy sleep habits improves mood, productivity, and overall quality of life.',
    },
    {
      'articleTitle': 'Depression: Silent Killer',
      'articleImage': 'assets/images/depression.jpg',
      'articleDetails':
          'Depression is a mood disorder that causes a persistent feeling of sadness and loss of interest. Also called major depressive disorder or clinical depression, it affects how you feel, think and behave and can lead to a variety of emotional and physical problems.',
    },
    {
      'articleTitle': 'Anxiety: The Fear Within',
      'articleImage': 'assets/images/anxiety.webp',
      'articleDetails':
          'Anxiety is your body’s natural response to stress. It’s a feeling of fear or apprehension about what’s to come. The first day of school, going to a job interview, or giving a speech may cause most people to feel fearful and nervous.',
    },
  ]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('Blogs'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd, vertical: AppTheme.spaceSm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppTheme.spaceMd),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Articles',
                        style: AppTheme.heading2,
                      )
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceMd),
                  Column(
                    children:
                        (data as List<Map<String, String>>).map((article) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppTheme.spaceLg),
                        child: ArticleCard(
                          articleTitle: article['articleTitle']!,
                          articleImage: article['articleImage']!,
                          articleDetails: article['articleDetails']!,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final String articleImage;
  final String articleTitle;
  final String articleDetails;

  const ArticleDetailScreen({
    super.key,
    required this.articleImage,
    required this.articleTitle,
    required this.articleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar(articleTitle),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryDark.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    child: Image.asset(articleImage, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: AppTheme.spaceXl),
                Container(
                  decoration: AppTheme.cardDecoration,
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articleTitle,
                          style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
                        ),
                        const SizedBox(height: AppTheme.spaceMd),
                        Divider(color: AppTheme.primaryPale),
                        const SizedBox(height: AppTheme.spaceMd),
                        Text(
                          articleDetails,
                          style: AppTheme.body,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String articleImage;
  final String articleTitle;
  final String articleDetails;

  const ArticleCard({
    super.key,
    required this.articleImage,
    required this.articleTitle,
    required this.articleDetails,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(
              articleImage: articleImage,
              articleTitle: articleTitle,
              articleDetails: articleDetails,
            ),
          ),
        );
      },
      child: Container(
        decoration: AppTheme.cardDecoration,
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              child: Image.asset(articleImage, fit: BoxFit.cover),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Text(
                  articleTitle,
                  style: AppTheme.heading3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
