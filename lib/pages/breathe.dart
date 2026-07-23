import 'package:flutter/material.dart';
import 'package:saathi/components/lottie_widget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> {
  bool isStarted = false;
  Timer? _timer;
  double _sliderValue = 0.0;
  final double _maxSliderValue = 1500.0; // 25 minutes (1500 sec)
  late AudioPlayer _audioPlayer;
  final String _audioPath =
      'https://res.cloudinary.com/dksnirztn/video/upload/v1729189988/mixkit-morning-birds-2472_1_ondanv.wav';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() async {
    if (isStarted) return;

    setState(() {
      isStarted = true;
    });

    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(UrlSource(_audioPath));
    } catch (e) {
      debugPrint('Audio playback note: $e');
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_sliderValue < _maxSliderValue) {
            _sliderValue += 1.0;
          } else {
            _stopTimer();
          }
        });
      }
    });
  }

  void _stopTimer() async {
    _timer?.cancel();
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('Audio stop note: $e');
    }
    if (mounted) {
      setState(() {
        isStarted = false;
      });
    }
  }

  void _rewind10Seconds() {
    setState(() {
      _sliderValue = (_sliderValue - 10.0).clamp(0.0, _maxSliderValue);
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<bool> _onWillPop(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DashboardPage(),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: AppTheme.surface,
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Sound Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceSm),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDark.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volume_up, color: AppTheme.primaryDark),
                            const SizedBox(width: AppTheme.spaceSm),
                            Text(
                              'Sound: Chirping Birds',
                              style: AppTheme.body.copyWith(
                                color: AppTheme.primaryDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Breathing Animation Text
                  Center(
                    child: Column(
                      children: [
                        isStarted
                            ? const Center(
                                child: LottieWidget(
                                    path: 'assets/animations/breathing.json'))
                            : GestureDetector(
                                onTap: _startTimer,
                                child: CircleAvatar(
                                  radius: 110,
                                  backgroundColor: AppTheme.primaryDark,
                                  child: Text(
                                    'Start',
                                    style: AppTheme.heading1.copyWith(color: AppTheme.textOnPrimary),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Timer Slider and Control Buttons
                  Column(
                    children: [
                      Text(
                        _formatTime(_sliderValue.toInt()),
                        style: AppTheme.heading1.copyWith(color: AppTheme.primaryDark),
                      ),
                      Slider(
                        value: _sliderValue,
                        max: _maxSliderValue,
                        activeColor: AppTheme.primaryDark,
                        inactiveColor: AppTheme.primaryPale,
                        onChanged: (double value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                      Text(
                        _formatTime(_maxSliderValue.toInt()),
                        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                      ),

                      const SizedBox(height: AppTheme.spaceLg),

                      // Play/Pause, Repeat and Backward buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.replay_10, color: AppTheme.primaryDark),
                            iconSize: 44,
                            tooltip: 'Rewind 10 seconds',
                            onPressed: _rewind10Seconds,
                          ),
                          isStarted
                              ? Center(
                                  child: ElevatedButton(
                                    onPressed: _stopTimer,
                                    style: AppTheme.primaryButtonStyle.copyWith(
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl, vertical: AppTheme.spaceMd),
                                      ),
                                    ),
                                    child: Text('Stop', style: AppTheme.button),
                                  ),
                                )
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: _startTimer,
                                    style: AppTheme.primaryButtonStyle.copyWith(
                                      padding: WidgetStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl, vertical: AppTheme.spaceMd),
                                      ),
                                    ),
                                    child: Text('Start', style: AppTheme.button),
                                  ),
                                ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
