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
  final double _maxSliderValue = 1500.0;
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

  void _startTimer() {
    if (isStarted) return;

    setState(() {
      isStarted = true;
    });

    _audioPlayer.setReleaseMode(ReleaseMode.loop); // Loop the audio
    _audioPlayer.play(UrlSource(_audioPath)); // Play the audio

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_sliderValue < _maxSliderValue) {
          _sliderValue += 1.0;
        } else {
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _audioPlayer.stop(); // Stop the audio
    setState(() {
      isStarted = false;
    });
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
                        padding:
                            const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceSm),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.volume_up, color: AppTheme.textOnPrimary),
                            const SizedBox(width: AppTheme.spaceSm),
                            Text(
                              'Sound: Chirping Birds',
                              style: AppTheme.body.copyWith(color: AppTheme.textOnPrimary),
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
                            ? Center(
                                child: LottieWidget(
                                    path: 'assets/animations/breathing.json'))
                            : GestureDetector(
                                onTap: _startTimer,
                                child: CircleAvatar(
                                  radius: 120,
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
                        "05:21",
                        style: AppTheme.heading3.copyWith(color: AppTheme.primaryDark),
                      ),
                      Slider(
                        value: _sliderValue,
                        max: _maxSliderValue,
                        activeColor: AppTheme.primaryDark,
                        inactiveColor: AppTheme.primaryPale,
                        onChanged: (double value) {},
                      ),
                      Text(
                        "25:00",
                        style: AppTheme.heading3.copyWith(color: AppTheme.primaryDark),
                      ),

                      const SizedBox(height: AppTheme.spaceLg),

                      // Play/Pause, Repeat and Backward buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10,
                                color: AppTheme.primaryDark),
                            iconSize: 40,
                            onPressed: () {},
                          ),
                          isStarted
                              ? Center(
                                  child: ElevatedButton(
                                    onPressed: isStarted ? _stopTimer : null,
                                    style: AppTheme.primaryButtonStyle.copyWith(
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl, vertical: AppTheme.spaceMd),
                                      )
                                    ),
                                    child: Text('Stop', style: AppTheme.button),
                                  ),
                                )
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: isStarted ? null : _startTimer,
                                    style: AppTheme.primaryButtonStyle.copyWith(
                                      padding: MaterialStateProperty.all(
                                        const EdgeInsets.symmetric(horizontal: AppTheme.spaceXl, vertical: AppTheme.spaceMd),
                                      )
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
