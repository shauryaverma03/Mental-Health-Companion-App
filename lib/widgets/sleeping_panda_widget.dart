import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class SleepingPandaWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final String retryButtonText;
  final bool showUpdateNotice;

  const SleepingPandaWidget({
    super.key,
    this.title = "Panda is Sleeping...",
    this.message = "Panda is taking a rest right now! This feature will be updated in the next update. Stay tuned! 🐼💤",
    this.onRetry,
    this.retryButtonText = "Check Again",
    this.showUpdateNotice = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.8),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryDark.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(110),
                child: Image.asset(
                  'assets/images/sleeping_panda.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceXl),
            if (showUpdateNotice) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  border: Border.all(color: AppTheme.primaryPale, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryDark, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Will be updated in next update',
                      style: AppTheme.bodySmall.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spaceMd),
            ],
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.heading1.copyWith(
                color: AppTheme.primaryDark,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceMd),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: AppTheme.body.copyWith(
                  color: AppTheme.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppTheme.spaceXl),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, color: AppTheme.textOnPrimary),
                label: Text(
                  retryButtonText,
                  style: AppTheme.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: AppTheme.textOnPrimary,
                  elevation: 3,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space2xl,
                    vertical: AppTheme.spaceMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
