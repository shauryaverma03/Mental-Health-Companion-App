import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class ContactProfessionals extends StatelessWidget {
  final Object data = ([
    {
      'doctorName': 'Dr. Elena Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety Expert',
      'doctorExperience': '50m',
      'doctorRating': 4.5,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
    },
    {
      'doctorName': 'Dr. Phos Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety Expert',
      'doctorExperience': '50m',
      'doctorRating': 4.5,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
    },
    {
      'doctorName': 'Dr. Elena Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety Expert',
      'doctorExperience': '50m',
      'doctorRating': 4.5,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
    },
    {
      'doctorName': 'Dr. Phos Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety Expert',
      'doctorExperience': '50m',
      'doctorRating': 4.5,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
    },
    {
      'doctorName': 'Dr. Phos Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety Expert',
      'doctorExperience': '50m',
      'doctorRating': 4.5,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
    }
  ]);
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
          appBar: AppTheme.standardAppBar('Contact Professionals'),
          body: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.backgroundGradient,
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppTheme.spaceSm),
                    children:
                        (data as List<Map<String, dynamic>>).map((doctor) {
                      return DoctorProfileCard(
                        doctorName: doctor['doctorName']!,
                        doctorImage: doctor['doctorImage']!,
                        doctorSpecialization: doctor['doctorSpecialization']!,
                        doctorExperience: doctor['doctorExperience']!,
                        doctorRating: doctor['doctorRating']!,
                        doctorRatingCount: doctor['doctorRatingCount']!,
                        doctorRatingPercentage:
                            doctor['doctorRatingPercentage']!,
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class DoctorProfileCard extends StatelessWidget {
  final String doctorName;
  final String doctorImage;
  final String doctorSpecialization;
  final String doctorExperience;
  final double doctorRating;
  final int doctorRatingCount;
  final double doctorRatingPercentage;

  const DoctorProfileCard({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.doctorSpecialization,
    required this.doctorExperience,
    required this.doctorRating,
    required this.doctorRatingCount,
    required this.doctorRatingPercentage,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceSm, vertical: AppTheme.spaceSm),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Container(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(doctorImage),
                ),
                SizedBox(width: AppTheme.spaceMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            doctorName,
                            style: AppTheme.heading3,
                          ),
                          SizedBox(width: AppTheme.spaceXs),
                          Icon(Icons.verified, color: Colors.orange, size: 20),
                        ],
                      ),
                      SizedBox(height: AppTheme.spaceXs),
                      Row(
                        children: [
                          Icon(Icons.psychology, color: AppTheme.textSecondary, size: 16),
                          SizedBox(width: 4),
                          Text(
                            doctorSpecialization,
                            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                          ),
                          SizedBox(width: AppTheme.spaceSm),
                          Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                          SizedBox(width: 4),
                          Text(
                            doctorExperience,
                            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppTheme.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  SizedBox(width: 4),
                  Text(
                    doctorRating.toString(),
                    style: AppTheme.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' (${(doctorRatingCount/1000).toStringAsFixed(1)}k)',
                    style: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.call, color: AppTheme.textOnPrimary, size: 16),
                label: Text(
                  'Contact',
                  style: AppTheme.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: AppTheme.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceSm),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
