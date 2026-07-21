import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class MoodScreen extends StatefulWidget {
  @override
  _MoodScreenState createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  double _currentValue = 3.0;
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
        appBar: AppTheme.standardAppBar('Assessment', actions: []),
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
                  "How are you feeling today?",
                  style: AppTheme.display,
                ),
                SizedBox(height: AppTheme.space3xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: AppTheme.spaceXl),
                        _buildLabelWithIcon(
                            "Excellent", "assets/svgs/excellent.svg", 5),
                        SizedBox(height: AppTheme.spaceXl),
                        _buildLabelWithIcon("Good", "assets/svgs/good.svg", 4),
                        SizedBox(height: AppTheme.spaceXl),
                        _buildLabelWithIcon("Fair", "assets/svgs/fair.svg", 3),
                        SizedBox(height: AppTheme.spaceXl),
                        _buildLabelWithIcon("Poor", "assets/svgs/poor.svg", 2),
                        SizedBox(height: AppTheme.spaceXl),
                        _buildLabelWithIcon("Worst", "assets/svgs/worst.svg", 1),
                      ],
                    ),
                    RotatedBox(
                      quarterTurns: 3,
                      child: Container(
                        width: 550, // Set the desired width for the slider
                        child: SliderTheme(
                          data: SliderThemeData(
                              activeTrackColor: AppTheme.primary,
                              inactiveTrackColor: AppTheme.primaryPale,
                              trackHeight: 30.0,
                              thumbShape:
                                  RoundSliderThumbShape(enabledThumbRadius: 25.0),
                              thumbColor: AppTheme.primaryDark,
                              overlayColor: AppTheme.primary.withOpacity(0.3),
                              overlayShape:
                                  RoundSliderOverlayShape(overlayRadius: 30.0),
                              valueIndicatorColor: AppTheme.primaryLight,
                              trackShape: RoundedRectSliderTrackShape(),
                              activeTickMarkColor: AppTheme.primaryLight,
                              inactiveTickMarkColor: AppTheme.primaryPale,
                              tickMarkShape: RoundSliderTickMarkShape()),
                          child: Slider(
                            value: _currentValue,
                            min: 1,
                            max: 5,
                            divisions: 4,
                            onChanged: (double value) {
                              setState(() {
                                _currentValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelWithIcon(String label, String svgPath, int position) {
    Color filterColor =
        _currentValue == position ? AppTheme.primaryDark : AppTheme.textSecondary.withOpacity(0.5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentValue = position.toDouble();
        });
      },
      child: Column(
        children: [
          Row(
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(
                  filterColor.withOpacity(_currentValue == position
                      ? 0.0
                      : 0.5), // Set the opacity for the filter
                  BlendMode.srcATop, // Blend mode to apply
                ),
                child: SvgPicture.asset(
                  svgPath,
                  width: 75,
                  height: 75,
                ),
              ),
              SizedBox(width: AppTheme.spaceMd),
            ],
          ),
          SizedBox(height: AppTheme.spaceLg),
        ],
      ),
    );
  }
}

