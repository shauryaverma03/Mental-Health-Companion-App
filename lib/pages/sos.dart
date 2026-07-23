import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:saathi/components/custom_sos_container.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/themes/app_theme.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final _storage = const FlutterSecureStorage();
  String _buddyName = 'My Buddy';
  String _buddyPhone = '';

  @override
  void initState() {
    super.initState();
    _loadBuddyInfo();
  }

  Future<void> _loadBuddyInfo() async {
    final name = await _storage.read(key: 'buddy_name');
    final phone = await _storage.read(key: 'buddy_phone');
    if (mounted) {
      setState(() {
        if (name != null && name.isNotEmpty) _buddyName = name;
        if (phone != null && phone.isNotEmpty) _buddyPhone = phone;
      });
    }
  }

  Future<void> _showUpdateBuddyDialog() async {
    final nameController = TextEditingController(text: _buddyName);
    final phoneController = TextEditingController(text: _buddyPhone);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        title: Text('Set Emergency Buddy', style: AppTheme.heading2),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Buddy Name',
                hintText: 'e.g. Alex',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: AppTheme.spaceMd),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Buddy Phone Number',
                hintText: 'e.g. +1 555-0199',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTheme.body.copyWith(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final newPhone = phoneController.text.trim();
              await _storage.write(key: 'buddy_name', value: newName);
              await _storage.write(key: 'buddy_phone', value: newPhone);
              if (mounted) {
                setState(() {
                  _buddyName = newName.isEmpty ? 'My Buddy' : newName;
                  _buddyPhone = newPhone;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Emergency Buddy set to $_buddyName!'),
                    backgroundColor: AppTheme.primaryDark,
                  ),
                );
              }
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _callBuddy() {
    if (_buddyPhone.isEmpty) {
      _showUpdateBuddyDialog();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          ),
          title: Row(
            children: [
              const Icon(Icons.call, color: AppTheme.primaryDark),
              const SizedBox(width: 10),
              Text('Contact $_buddyName', style: AppTheme.heading2),
            ],
          ),
          content: Text(
            'Buddy: $_buddyName\nPhone: $_buddyPhone',
            style: AppTheme.body,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dialing $_buddyName ($_buddyPhone)...'),
                    backgroundColor: AppTheme.primaryDark,
                  ),
                );
              },
              style: AppTheme.primaryButtonStyle,
              child: const Text('Call Now'),
            ),
          ],
        ),
      );
    }
  }

  void _callHelpline(String name, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        ),
        title: Row(
          children: [
            const Icon(Icons.phone_in_talk, color: AppTheme.primary),
            const SizedBox(width: 10),
            Text(name, style: AppTheme.heading2),
          ],
        ),
        content: Text(
          'Connecting to $name hotline ($number). Help is available 24/7.',
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling $name ($number)...'),
                  backgroundColor: AppTheme.primaryDark,
                ),
              );
            },
            style: AppTheme.primaryButtonStyle,
            child: const Text('Call Hotline'),
          ),
        ],
      ),
    );
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
                        onPressed: _callBuddy,
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
                              const SizedBox(width: AppTheme.spaceMd),
                              Text(
                                _buddyPhone.isEmpty ? 'Set Your Buddy' : 'Call $_buddyName',
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
                          color: AppTheme.primaryPale,
                          thickness: 2,
                          indent: 50,
                          endIndent: 8,
                        ),
                      ),
                      Text(
                        'or',
                        style: AppTheme.body.copyWith(color: AppTheme.primaryDark, fontWeight: FontWeight.bold),
                      ),
                      const Expanded(
                        child: Divider(
                          color: AppTheme.primaryPale,
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
                            'Emergency Helplines',
                            style: AppTheme.heading3.copyWith(color: AppTheme.textPrimary),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceLg),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: CustomButton(
                            onPressed: () => _callHelpline('Mental Health Tele-MANAS', '14416'),
                            text: 'Mental Health Helpline (14416)',
                            icon: Icons.phone,
                            color: AppTheme.primaryDark,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceMd),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: CustomButton(
                            onPressed: () => _callHelpline('National Emergency Services', '112'),
                            text: 'Emergency Services (112)',
                            icon: Icons.help,
                            color: Colors.redAccent,
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
                            'Update Emergency Buddy',
                            style: AppTheme.heading3.copyWith(color: AppTheme.textPrimary),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spaceMd),
                        Text(
                          'Keep your trusted friend or family member updated so they are one tap away when you need help.',
                          style: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spaceLg),
                        CustomButton(
                          onPressed: _showUpdateBuddyDialog,
                          text: 'Edit Buddy Contact',
                          icon: Icons.edit_note_rounded,
                          color: AppTheme.primary,
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
