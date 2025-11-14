import 'package:flutter/material.dart';
import 'package:genai/themes/colors.dart';

class BasicButton extends StatelessWidget {
  /// BasicButton(text, onPressed)
  /// Optional named parameters let you override colors and sizing from the call site
  /// without changing other files.
  const BasicButton(
    this.text,
    this.onPressed, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.shadowColor,
    this.width = 100,
    this.height = 50,
    this.borderRadius = 12.0,
  });

  final String text;
  final VoidCallback onPressed;

  // Optional overrides (if null, fallback to theme or a gentle elder light-blue)
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? shadowColor;

  // Size / shape customization (sensible defaults preserved)
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    // Resolve colors: prefer explicit prop, then theme, then a gentle elder light-blue
    final Color defaultElderLightBlue = const Color(0xFF9ED8F6); // soft light-blue

    final Color resolvedBg = backgroundColor ??
        Theme.of(context).colorScheme.primary ??
        defaultElderLightBlue; // previously used Mint

    final Color resolvedFg = foregroundColor ??
        Theme.of(context).colorScheme.onPrimary ??
        Colors.white;

    final Color resolvedShadow =
        shadowColor ?? resolvedBg.withOpacity(0.6); // subtle shadow by default

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center, // Center the buttons vertically
      crossAxisAlignment:
          CrossAxisAlignment.center, // Stretch the buttons horizontally
      children: [
        SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              foregroundColor: resolvedFg, // Text / icon color
              backgroundColor: resolvedBg, // Button background (now light blue)
              padding:
                  const EdgeInsets.symmetric(vertical: 16), // Increase height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              elevation: 5, // Add shadow for depth
              shadowColor: resolvedShadow,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              minimumSize: Size(width, height), // Minimum size of the button
              tapTargetSize: MaterialTapTargetSize.padded,
              animationDuration: const Duration(milliseconds: 200),
            ),
            child: Text(text),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}