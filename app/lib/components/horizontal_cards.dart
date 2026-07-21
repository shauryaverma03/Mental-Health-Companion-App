import 'package:flutter/material.dart';
import 'package:saathi/themes/app_theme.dart';

class CardItem {
  final IconData icon;
  final String label;
  final Widget path;

  CardItem({required this.icon, required this.label, required this.path});
}

class HorizontalCards extends StatelessWidget {
  final List<CardItem> items;

  HorizontalCards({required this.items});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => items[index].path,
                  ),
                );
              },
              child: Container(
                width: 120,
                decoration: AppTheme.cardDecoration,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      items[index].icon,
                      size: 40,
                      color: AppTheme.primary,
                    ),
                    SizedBox(height: AppTheme.spaceSm),
                    Text(
                      items[index].label,
                      textAlign: TextAlign.center,
                      style: AppTheme.body.copyWith(
                        color: AppTheme.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
