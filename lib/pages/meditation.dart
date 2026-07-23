import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:saathi/components/lottie_widget.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  int _duration = 30;
  final CountDownController _controller = CountDownController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Dispose of animation controller to prevent memory leaks
    super.dispose();
  }

  void _incrementDuration() {
    setState(() {
      _duration += 30;
    });
  }

  void _decrementDuration() {
    if (_duration > 30) {
      setState(() {
        _duration -= 30;
      });
    }
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppTheme.standardAppBar('Meditate'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: Center(
            // Center the entire page content
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: const SizedBox(
                      height: 150,
                      child: LottieWidget(
                        path: 'assets/animations/43792-yoga-se-hi-hoga.json',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Text(
                    'Be Calm and Breathe Slowly',
                    style: AppTheme.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Text(
                    'Duration: ${_duration ~/ 60} min ${_duration % 60} sec',
                    style: AppTheme.heading3.copyWith(color: AppTheme.primaryDark),
                  ),
                  const SizedBox(height: AppTheme.spaceSm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, size: 32),
                        onPressed: _incrementDuration,
                        color: AppTheme.primaryDark,
                      ),
                      const SizedBox(width: AppTheme.spaceMd),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, size: 32),
                        onPressed: _decrementDuration,
                        color: AppTheme.primaryDark,
                      ),
                    ],
                  ), // Reduced space
                  const SizedBox(height: AppTheme.spaceMd),
                  CircularCountDownTimer(
                    duration: _duration, // Use the user-selected duration
                    initialDuration: 0,
                    controller: _controller,
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: MediaQuery.of(context).size.width / 2.5, // keep it square
                    ringColor: AppTheme.primaryPale,
                    fillColor: AppTheme.primary,
                    backgroundColor: AppTheme.surface,
                    strokeWidth: 8.0,
                    strokeCap: StrokeCap.round,
                    textStyle: AppTheme.heading1.copyWith(
                      color: AppTheme.primaryDark,
                    ),
                    textFormat: CountdownTextFormat.S,
                    isReverse: false,
                    isReverseAnimation: false,
                    isTimerTextShown: true,
                    autoStart: false,
                    onStart: () {
                      debugPrint('Countdown Started');
                      _isCompleted = false; // Reset completion flag when starting
                      _animationController
                          .forward(); // Start fade animation when countdown starts
                    },
                    onComplete: () {
                      if (_isCompleted) {
                        _isCompleted = false;

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                            ),
                            title: Text('Meditation Complete!', style: AppTheme.heading2),
                            content: Text('Well done on your meditation!', style: AppTheme.body),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK', style: AppTheme.button.copyWith(color: AppTheme.primaryDark)),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppTheme.spaceXl),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Start and Pause button column
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _button(
                              title: "Start",
                              onPressed: () {
                                _controller.restart(
                                    duration:
                                        _duration); // Start with the selected duration
                                _animationController
                                    .forward(); // Start fade animation when countdown starts
                              },
                            ),
                            const SizedBox(width: AppTheme.spaceLg),
                            _button(
                              title: "Resume",
                              onPressed: () => _controller.resume(),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spaceMd), // Space between the two rows

                        // Pause and Restart button row
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _button(
                              title: "Pause",
                              onPressed: () => _controller.pause(),
                            ),
                            const SizedBox(width: AppTheme.spaceLg),
                            _button(
                              title: "Restart",
                              onPressed: () => _controller.restart(
                                  duration:
                                      _duration), // Restart with the selected duration
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return SizedBox(
      width: 140, // Fixed width for buttons for uniformity
      child: ElevatedButton(
        style: AppTheme.primaryButtonStyle.copyWith(
          padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: AppTheme.spaceMd)),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: AppTheme.button,
        ),
      ),
    );
  }
}
