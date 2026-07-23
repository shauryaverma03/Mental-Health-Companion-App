import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class ContactProfessionals extends StatelessWidget {
  final Object data = ([
    {
      'doctorName': 'Dr. Elena Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Anxiety & PTSD Specialist',
      'doctorExperience': '12 yrs exp',
      'doctorRating': 4.9,
      'doctorRatingCount': 1200,
      'doctorRatingPercentage': 99.57,
      'doctorPhone': '+1 (555) 234-5678',
    },
    {
      'doctorName': 'Dr. Phos Gray',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Cognitive Behavioral Therapy',
      'doctorExperience': '8 yrs exp',
      'doctorRating': 4.8,
      'doctorRatingCount': 950,
      'doctorRatingPercentage': 98.2,
      'doctorPhone': '+1 (555) 876-5432',
    },
    {
      'doctorName': 'Dr. Marcus Vance',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Depression & Stress Expert',
      'doctorExperience': '15 yrs exp',
      'doctorRating': 4.95,
      'doctorRatingCount': 2100,
      'doctorRatingPercentage': 99.9,
      'doctorPhone': '+1 (555) 345-6789',
    },
    {
      'doctorName': 'Dr. Sarah Lin',
      'doctorImage': 'assets/images/doctor.png',
      'doctorSpecialization': 'Mindfulness & Wellness Coach',
      'doctorExperience': '10 yrs exp',
      'doctorRating': 4.85,
      'doctorRatingCount': 1400,
      'doctorRatingPercentage': 98.9,
      'doctorPhone': '+1 (555) 456-7890',
    },
  ]);

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
                        doctorRating: (doctor['doctorRating'] as num).toDouble(),
                        doctorRatingCount: doctor['doctorRatingCount'] as int,
                        doctorRatingPercentage:
                            (doctor['doctorRatingPercentage'] as num).toDouble(),
                        doctorPhone: doctor['doctorPhone'] ?? '+1 (555) 000-0000',
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
  final String doctorPhone;

  const DoctorProfileCard({
    super.key,
    required this.doctorName,
    required this.doctorImage,
    required this.doctorSpecialization,
    required this.doctorExperience,
    required this.doctorRating,
    required this.doctorRatingCount,
    required this.doctorRatingPercentage,
    required this.doctorPhone,
  });

  void _showContactOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      backgroundColor: AppTheme.surface,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(AppTheme.spaceLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(doctorImage),
                  ),
                  const SizedBox(width: AppTheme.spaceMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctorName, style: AppTheme.heading2),
                        Text(doctorSpecialization,
                            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spaceXl),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryLight,
                  child: Icon(Icons.phone, color: AppTheme.primaryDark),
                ),
                title: Text('Call Professional', style: AppTheme.heading3),
                subtitle: Text(doctorPhone, style: AppTheme.bodySmall),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Calling $doctorName ($doctorPhone)...'),
                      backgroundColor: AppTheme.primaryDark,
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppTheme.primaryLight,
                  child: Icon(Icons.calendar_today, color: AppTheme.primaryDark),
                ),
                title: Text('Book Consultation', style: AppTheme.heading3),
                subtitle: const Text('Schedule a 1-on-1 confidential session', style: AppTheme.bodySmall),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                      ),
                      title: Text('Appointment Requested', style: AppTheme.heading2),
                      content: Text(
                        'Your consultation request with $doctorName has been submitted. Their clinic assistant will reach out shortly.',
                        style: AppTheme.body,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Done', style: AppTheme.button.copyWith(color: AppTheme.primaryDark)),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: AppTheme.spaceMd),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceSm, vertical: AppTheme.spaceSm),
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(doctorImage),
              ),
              const SizedBox(width: AppTheme.spaceMd),
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
                        const SizedBox(width: AppTheme.spaceXs),
                        const Icon(Icons.verified, color: Colors.orange, size: 20),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: AppTheme.textSecondary, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            doctorSpecialization,
                            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: AppTheme.textSecondary, size: 16),
                        const SizedBox(width: 4),
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
          const SizedBox(height: AppTheme.spaceLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
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
                onPressed: () => _showContactOptions(context),
                icon: const Icon(Icons.call, color: AppTheme.textOnPrimary, size: 16),
                label: const Text(
                  'Contact',
                  style: AppTheme.button,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: AppTheme.textOnPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceSm),
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
