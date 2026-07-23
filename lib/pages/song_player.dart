import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:saathi/themes/app_theme.dart';

class SongPlayerPage extends StatefulWidget {
  final String songPath;
  final String songName;
  final String catName;

  SongPlayerPage(
      {required this.songPath, required this.songName, required this.catName});

  @override
  _SongPlayerPageState createState() => _SongPlayerPageState();
}

class _SongPlayerPageState extends State<SongPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(widget.songPath));
      }
      if (mounted) {
        setState(() {
          isPlaying = !isPlaying;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to stream track right now. Please check your network connection!"),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  void _seekTo(double value) {
    final newPosition = Duration(seconds: value.toInt());
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    final double maxSeconds = totalDuration.inSeconds > 0
        ? totalDuration.inSeconds.toDouble()
        : 1.0;
    final double currentSeconds = currentPosition.inSeconds.toDouble().clamp(0.0, maxSeconds);

    return Scaffold(
      appBar: AppTheme.standardAppBar('Now Playing'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Song Image or GIF with network error fallback
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceXl),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                child: Image.network(
                  widget.catName,
                  width: 250,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 250,
                      height: 250,
                      color: AppTheme.primaryLight,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.music_note, size: 80, color: AppTheme.primaryDark),
                          SizedBox(height: 10),
                          Text('Therapy Audio', style: AppTheme.heading3),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Song Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceMd, horizontal: AppTheme.spaceLg),
              child: Text(
                'Now Playing: ${widget.songName}',
                style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
                textAlign: TextAlign.center,
              ),
            ),

            // Music Player Controls
            Slider(
              activeColor: AppTheme.primaryDark,
              inactiveColor: AppTheme.primaryPale,
              min: 0.0,
              max: maxSeconds,
              value: currentSeconds,
              onChanged: totalDuration.inSeconds > 0 ? _seekTo : null,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(currentPosition),
                    style: AppTheme.body.copyWith(color: AppTheme.primaryDark),
                  ),
                  Text(
                    _formatDuration(totalDuration),
                    style: AppTheme.body.copyWith(color: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spaceXl),

            // Play/Pause Button
            IconButton(
              iconSize: 80,
              icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
              color: AppTheme.primaryDark,
              onPressed: _togglePlayPause,
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format duration in MM:SS
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
