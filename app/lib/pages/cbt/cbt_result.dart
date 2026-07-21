import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class CBTResultPage extends StatelessWidget {
  final int phqTotal;
  final int gadTotal;
  final List<int> phobiaScores;
  final int workSocialTotal;

  CBTResultPage({
    required this.phqTotal,
    required this.gadTotal,
    required this.phobiaScores,
    required this.workSocialTotal,
  });

  String _getPHQSeverity() {
    if (phqTotal >= 20) return "Severe";
    if (phqTotal >= 15) return "Moderately Severe";
    if (phqTotal >= 10) return "Moderate";
    if (phqTotal >= 5) return "Mild";
    return "None";
  }

  String _getGADSeverity() {
    if (gadTotal >= 16) return "Severe Anxiety";
    if (gadTotal >= 11) return "Moderate Anxiety";
    if (gadTotal >= 5) return "Mild Anxiety";
    return "None";
  }

  String _getPhobiaAssessment() {
    return phobiaScores.any((score) => score >= 4)
        ? "Further assessment recommended for possible phobia"
        : "No significant phobia symptoms detected";
  }

  String _getWorkSocialSeverity() {
    if (workSocialTotal >= 20) return "Severe Impairment";
    if (workSocialTotal >= 10) return "Moderate Impairment";
    return "Low Impairment";
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title, style: AppTheme.heading2),
          content: Text(content, style: AppTheme.body),
          backgroundColor: AppTheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusCard)),
          ),
          actions: [
            TextButton(
              child: Text(
                'Close',
                style: AppTheme.button.copyWith(color: AppTheme.primary),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildResultCard(BuildContext context, String title, String score, String severity, String description) {
    return GestureDetector(
      onTap: () => _showInfoDialog(context, title, description),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spaceLg),
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        decoration: AppTheme.cardDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTheme.heading2),
                Icon(Icons.info_outline, color: AppTheme.primary, size: 20),
              ],
            ),
            SizedBox(height: AppTheme.spaceSm),
            Text(score, style: AppTheme.body),
            SizedBox(height: AppTheme.spaceXs),
            Text(
              "Severity: $severity",
              style: AppTheme.body.copyWith(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTheme.standardAppBar('CBT Results'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: ListView(
            children: [
              Text("Test Results", style: AppTheme.display),
              SizedBox(height: AppTheme.spaceXl),
              
              _buildResultCard(
                context,
                "PHQ-9 (Depression)",
                "Total Score: $phqTotal",
                _getPHQSeverity(),
                "The Patient Health Questionnaire (PHQ) is a self-administered version of the PRIME-MD diagnostic instrument for common mental disorders. The PHQ-9 is the depression module.",
              ),
              
              _buildResultCard(
                context,
                "GAD-7 (Anxiety)",
                "Total Score: $gadTotal",
                _getGADSeverity(),
                "The Generalized Anxiety Disorder-7 (GAD-7) is a brief self-report scale to measure anxiety levels.",
              ),
              
              _buildResultCard(
                context,
                "Phobia Assessment",
                "Phobia Indicators Checked",
                _getPhobiaAssessment(),
                "This section assesses common phobias by rating symptoms on a scale from “0” (not at all) to “4” (extreme fear).",
              ),
              
              _buildResultCard(
                context,
                "Work and Social Adjustment",
                "Total Score: $workSocialTotal",
                _getWorkSocialSeverity(),
                "The Work and Social Adjustment Scale (WSAS) measures how mental health problems affect a person’s ability to work and function socially.",
              ),
              
              SizedBox(height: AppTheme.spaceLg),
              Container(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                decoration: BoxDecoration(
                  color: AppTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                  border: Border.all(color: AppTheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: AppTheme.error),
                    SizedBox(width: AppTheme.spaceMd),
                    Expanded(
                      child: Text(
                        "Important Note: These results are for informational purposes only and are not a diagnostic tool. Please consult a healthcare professional for a proper diagnosis.",
                        style: AppTheme.bodySmall.copyWith(color: AppTheme.error),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.space3xl),
            ],
          ),
        ),
      ),
    );
  }
}
