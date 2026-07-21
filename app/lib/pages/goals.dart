import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class GoalScreen extends StatelessWidget {
  const GoalScreen({super.key});

  Widget _buildGoalCard(BuildContext context, String title, IconData icon, Widget route) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => route),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceLg),
        decoration: AppTheme.cardDecoration,
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(AppTheme.spaceMd),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.primaryDark),
          ),
          title: Text(title, style: AppTheme.heading2),
          trailing: Icon(Icons.arrow_forward_ios_sharp, color: AppTheme.primary, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('Goals'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Start a New Challenge",
                style: AppTheme.display,
              ),
              SizedBox(height: AppTheme.space2xl),
              _buildGoalCard(context, 'Get Fit', Icons.fitness_center, const FirstRoute()),
              _buildGoalCard(context, 'Better Sleep', Icons.bedtime, const ThirdRoute()),
              _buildGoalCard(context, 'Live Healthier', Icons.favorite, const SecondRoute()),
            ],
          ),
        ),
      ),
    );
  }
}

class FirstRoute extends StatelessWidget {
  const FirstRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('Get Fit'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Text(
          '1. Set clear goals for what you want to achieve and create a plan to help you get there. Consider factors such as your fitness level, time available, and any equipment you may need.\n\n'
          '2. Choose activities that you find enjoyable, such as jogging, swimming, cycling or weightlifting. This will help you stay motivated and make it easier to stick to your fitness routine.',
          style: AppTheme.body,
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('Live Healthier'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Text(
          '1. Exercise can improve your physical health, mental health, and mood. Aim to exercise for at least 30 minutes a day, five days a week.\n\n'
          '2. Make sure you are eating plenty of fruits, vegetables, whole grains, lean proteins, and healthy fats. Avoid processed and junk foods as much as possible.',
          style: AppTheme.body,
        ),
      ),
    );
  }
}

class ThirdRoute extends StatelessWidget {
  const ThirdRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('Better Sleep'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Text(
          "1. Try to go to bed and wake up at the same time every day, even on weekends. This helps regulate your body's internal clock and can improve the quality of your sleep.\n\n"
          "2. Create a relaxing bedtime routine to help signal to your body that it's time to sleep. This might include taking a warm bath, reading a book, or practicing meditation or yoga.",
          style: AppTheme.body,
        ),
      ),
    );
  }
}

