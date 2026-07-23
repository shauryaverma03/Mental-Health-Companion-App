import 'package:flutter/material.dart';
import 'package:saathi/pages/login.dart';
import 'package:saathi/themes/app_theme.dart';

class HeroPage extends StatefulWidget {
  const HeroPage({super.key});

  @override
  State<HeroPage> createState() => _HeroPageState();
}

class _HeroPageState extends State<HeroPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl),
            child: Column(
              children: [
                SizedBox(height: AppTheme.space3xl),
                Text(
                  "Welcome to Saathi",
                  style: AppTheme.display.copyWith(color: AppTheme.primaryDark),
                ),
                SizedBox(height: AppTheme.spaceMd),
                Text(
                  "Your mental health companion",
                  style: AppTheme.heading2.copyWith(color: AppTheme.textSecondary),
                ),
                SizedBox(height: AppTheme.spaceXl),
                Flexible(
                  fit: FlexFit.tight,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Image.asset(
                        'assets/svgs/welcome.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.space2xl),
                FadeTransition(
                  opacity: _opacityAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      },
                      style: AppTheme.primaryButtonStyle.copyWith(
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.fromLTRB(50, 20, 50, 20),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: AppTheme.button.copyWith(fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppTheme.space3xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}