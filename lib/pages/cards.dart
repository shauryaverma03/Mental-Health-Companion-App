import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class FlashCard extends StatelessWidget {
  final List<String> messages = [
    'You are stronger than you think.',
    'Believe in yourself!',
    'You are doing amazing, don’t give up!',
    'Every day is a new beginning.',
    'You are loved and appreciated.',
    'Your potential is limitless.',
    'Keep pushing, success is near.',
    'Good things take time, be patient.',
    'You are not alone in this journey.',
  ];

  final List<String> images = [
    'assets/images/aurora.jpg',
    'assets/images/road.jpg',
    'assets/images/leaf.jpg',
    'assets/images/trail.jpg',
  ];

  FlashCard() {
    images.shuffle();
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppTheme.standardAppBar('Affirmations'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.spaceMd),
                Text(
                  "It's Okay! We got you.",
                  style: AppTheme.heading2,
                ),
                const SizedBox(height: AppTheme.spaceSm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceSm),
                    child: CardSwiper(
                      cardsCount: messages.length,
                      numberOfCardsDisplayed: 3,
                      scale: 0.9,
                      padding: const EdgeInsets.all(AppTheme.spaceMd),
                      isLoop: true,
                      cardBuilder:
                          (context, index, percentThresholdX, percentThresholdY) {
                        return _buildCard(
                            messages[index], images[index % images.length]);
                      },
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

  Widget _buildCard(String message, String imagePath) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(AppTheme.spaceMd),
      decoration: AppTheme.cardDecoration,
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          image: DecorationImage(
            image: AssetImage(imagePath),
            opacity: 0.8,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
