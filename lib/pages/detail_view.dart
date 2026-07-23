import 'package:flutter/material.dart';
import 'package:saathi/pages/journal.dart';
import 'package:saathi/themes/app_theme.dart';

class DetailView extends StatelessWidget {
  final String title;
  final String content;

  const DetailView({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Journal(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppTheme.standardAppBar(title),
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
                  title,
                  style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
                ),
                const SizedBox(height: AppTheme.spaceMd),
                Text(
                  content,
                  style: AppTheme.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
