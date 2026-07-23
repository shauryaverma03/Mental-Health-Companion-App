import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/pages/detail_view.dart';
import 'package:saathi/themes/app_theme.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  final TextEditingController _journalController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final _storage = const FlutterSecureStorage();

  List<Map<String, String>> _journalEntries = [
    {
      'timeStamp': '02/08',
      'title': 'Therapy Session Reflection',
      'content':
          'Discussed coping mechanisms for anxiety and stress management techniques with my doctor. Feeling hopeful.'
    },
    {
      'timeStamp': '11/07',
      'title': 'Mindfulness Practice',
      'content':
          'Practiced mindfulness meditation for 30 minutes today. Felt much more relaxed and centered afterwards.'
    },
    {
      'timeStamp': '23/06',
      'title': 'Support Group Meeting',
      'content':
          'Attended a support group meeting. Shared experiences and received warm encouragement from everyone.'
    }
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedJournalEntries();
  }

  Future<void> _loadSavedJournalEntries() async {
    try {
      final savedData = await _storage.read(key: 'user_journal_entries');
      if (savedData != null && savedData.isNotEmpty) {
        final List<dynamic> parsed = jsonDecode(savedData);
        if (parsed.isNotEmpty && mounted) {
          setState(() {
            _journalEntries = parsed
                .map((e) => Map<String, String>.from(e as Map))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading journal entries: $e');
    }
  }

  Future<void> _saveJournalEntries() async {
    try {
      await _storage.write(
        key: 'user_journal_entries',
        value: jsonEncode(_journalEntries),
      );
    } catch (e) {
      debugPrint('Error saving journal entries: $e');
    }
  }

  void _submitJournalEntry() {
    final content = _journalController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please write something before submitting your journal!'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    final String title = _titleController.text.trim().isEmpty
        ? 'Personal Journal Entry'
        : _titleController.text.trim();
    final String timeStamp = DateFormat('dd/MM').format(DateTime.now());

    setState(() {
      _journalEntries.insert(0, {
        'timeStamp': timeStamp,
        'title': title,
        'content': content,
      });
      _journalController.clear();
      _titleController.clear();
    });

    _saveJournalEntries();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white),
            SizedBox(width: 10),
            Text('Journal entry saved successfully!'),
          ],
        ),
        backgroundColor: AppTheme.primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _journalController.dispose();
    _titleController.dispose();
    super.dispose();
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
        appBar: AppTheme.standardAppBar('Journal'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppTheme.spaceSm),
                    TextField(
                      controller: _titleController,
                      style: AppTheme.body,
                      decoration: InputDecoration(
                        hintText: 'Entry Title (optional)...',
                        hintStyle: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: const BorderSide(color: AppTheme.primaryPale, width: 1),
                        ),
                        filled: true,
                        fillColor: AppTheme.surface.withOpacity(0.8),
                        contentPadding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),
                    TextField(
                      controller: _journalController,
                      style: AppTheme.body,
                      decoration: InputDecoration(
                        hintText: 'Write your thoughts, feelings, or day reflection here...',
                        hintStyle: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: const BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: const BorderSide(color: AppTheme.primaryPale, width: 1),
                        ),
                        filled: true,
                        fillColor: AppTheme.surface.withOpacity(0.8),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: AppTheme.spaceXl),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: _submitJournalEntry,
                        icon: const Icon(Icons.send, color: AppTheme.textOnPrimary, size: 20),
                        label: const Text('Save Entry', style: AppTheme.button),
                        style: AppTheme.primaryButtonStyle,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xl),
                    Text(
                      'Past Journal Entries',
                      style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _journalEntries.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.spaceMd),
                          child: CardRow(
                            index: index,
                            time: _journalEntries[index]['timeStamp']!,
                            title: _journalEntries[index]['title']!,
                            content: _journalEntries[index]['content']!,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardRow extends StatelessWidget {
  final int index;
  final String time;
  final String title;
  final String content;

  const CardRow({
    Key? key,
    required this.index,
    required this.time,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 70,
            decoration: AppTheme.cardDecoration.copyWith(
              color: AppTheme.primaryPale.withOpacity(0.4),
            ),
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            child: Center(
              child: Text(
                time,
                style: AppTheme.heading3.copyWith(color: AppTheme.primaryDark),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spaceMd),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailView(
                      title: title,
                      content: content,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: AppTheme.cardDecoration,
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.heading2,
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    Text(
                      content,
                      style: AppTheme.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
