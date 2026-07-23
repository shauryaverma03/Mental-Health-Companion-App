import 'package:flutter/material.dart';
import 'package:saathi/pages/cbt/cbt.dart';
import 'package:saathi/themes/app_theme.dart';

class Disclaimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('CBT Test Introduction'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome to the CBT Test',
                style: AppTheme.heading1,
              ),
              SizedBox(height: AppTheme.spaceXl),
              Text(
                'This test helps to assess your emotional and mental well-being through a series of questions. '
                'Please answer honestly, as the results will be used to provide personalized support.',
                style: AppTheme.body,
              ),
              SizedBox(height: AppTheme.spaceXl),
              Text(
                'Remember, there are no right or wrong answers. Just reflect on how you feel.',
                style: AppTheme.body,
              ),
              SizedBox(height: AppTheme.space3xl),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: AppTheme.primaryButtonStyle,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CBTTestPage()),
                      );
                    },
                    child: Text(
                      'Start Test',
                      style: AppTheme.button,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
