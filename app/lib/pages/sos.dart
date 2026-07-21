import 'package:flutter/material.dart';
import 'package:saathi/components/custom_sos_container.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class SosScreen extends StatelessWidget {
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
        appBar: AppTheme.standardAppBar('SOS'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: AppTheme.spaceMd),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceMd),
                    decoration: AppTheme.cardDecoration,
                    child: ElevatedButton(
                        onPressed: () {
                          () {};
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.surface,
                          foregroundColor: AppTheme.primaryDark,
                          padding:
                              const EdgeInsets.symmetric(vertical: AppTheme.spaceXl, horizontal: 0),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.radiusXl)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.call, color: AppTheme.primaryDark, size: 28),
                              const SizedBox(
                                  width:
                                      AppTheme.spaceMd), // Add some space between the icon and the text
                              Text(
                                'Call your buddy',
                                style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
                              ),
                            ],
                          ),
                        )),
                  ),
                  const SizedBox(height: AppTheme.spaceLg),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(
                          color: AppTheme.surface,
                          thickness: 2,
                          indent: 50,
                          endIndent: 8,
                        ),
                      ),
                      Text(
                        'or',
                        style: AppTheme.body.copyWith(color: AppTheme.surface, fontWeight: FontWeight.bold),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppTheme.surface,
                          thickness: 2,
                          indent: 8,
                          endIndent: 50,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spaceXl),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
                    padding: const EdgeInsets.fromLTRB(AppTheme.spaceLg, AppTheme.spaceLg, AppTheme.spaceLg, AppTheme.spaceXl),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Emergency Contacts',
                            style: AppTheme.heading3.copyWith(color: AppTheme.textPrimary),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceLg),
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
                          child: CustomButton(
                            onPressed: () {},
                            text: 'Helpline',
                            icon: Icons.phone,
                            color: Colors.blue, // Pass the color argument
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceMd),
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 5, 25, 0),
                          child: CustomButton(
                            onPressed: () {},
                            text: 'Helpline',
                            icon: Icons.help,
                            color: Colors.green, // Pass the color argument
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXl),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
                    padding: const EdgeInsets.all(AppTheme.spaceLg),
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            'Update Buddy',
                            style: AppTheme.heading3.copyWith(color: AppTheme.textPrimary),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceMd),
                        Text(
                          'You can update your buddy to keep them informed about your whereabouts.',
                          style: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceLg),
                        CustomButton(
                          onPressed: () {},
                          text: 'Update Buddy',
                          icon: Icons.info,
                          color: Colors.orange, // Pass the color argument
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
