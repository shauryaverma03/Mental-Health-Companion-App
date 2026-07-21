import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: AppTheme.primary,
          borderRadius: BorderRadius.circular(AppTheme.radiusButton),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Center(
          child: Text(
            text,
            style: AppTheme.button,
          ),
        ),
      ),
    );
  }
}
