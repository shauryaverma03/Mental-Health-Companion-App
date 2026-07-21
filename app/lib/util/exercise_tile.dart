import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class ExerciseTile extends StatelessWidget {
  final icon;
  final String exerciseName;
  final int numberOfExercise;
  final color;
  final Function onTap;

  const ExerciseTile({
    super.key,
    required this.icon,
    required this.exerciseName,
    required this.numberOfExercise,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          padding: EdgeInsets.all(AppTheme.spaceLg),
          decoration: AppTheme.cardDecoration,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusButton),
                child: Container(
                  padding: EdgeInsets.all(AppTheme.spaceLg),
                  color: color,
                  child: Icon(
                    icon,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: AppTheme.spaceMd,
              ),
              Expanded(
                child: Text(
                  exerciseName,
                  style: AppTheme.heading2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
