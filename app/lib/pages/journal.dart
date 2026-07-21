import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/pages/detail_view.dart';
import 'package:saathi/themes/app_theme.dart';

class Journal extends StatefulWidget {
  const Journal({super.key});

  @override
  State<Journal> createState() => _JournalState();
}

class _JournalState extends State<Journal> {
  TextEditingController field1 = TextEditingController();
  TextEditingController field2 = TextEditingController();
  TextEditingController field3 = TextEditingController();
  FocusNode focusNode = FocusNode();

  final List<Map<String, String>> data = [
    {
      'timeStamp': '2/8',
      'title': 'Therapy Session',
      'content':
          'Discussed coping mechanisms for anxiety and stress management techniques.'
    },
    {
      'timeStamp': '11/07',
      'title': 'Mindfulness Practice',
      'content':
          'Practiced mindfulness meditation for 30 minutes. Felt more relaxed and centered afterwards.'
    },
    {
      'timeStamp': '23/06',
      'title': 'Support Group Meeting',
      'content':
          'Attended a support group meeting. Shared experiences and received encouragement from others.'
    }
  ];

  @override
  void initState() {
    super.initState();
    field1.text = "";
    field2.text = "";
    field3.text = "";
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
                    const SizedBox(height: AppTheme.spaceMd),
                    TextField(
                      controller: field1,
                      style: AppTheme.body,
                      decoration: InputDecoration(
                        hintText: 'Write your journal here...',
                        hintStyle: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: BorderSide(color: AppTheme.primary, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                          borderSide: BorderSide(
                              color: AppTheme.primaryPale, width: 1),
                        ),
                        filled: true,
                        fillColor: AppTheme.surface.withOpacity(0.8),
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: AppTheme.spaceXl),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.send, color: AppTheme.textOnPrimary, size: 20),
                        label: Text('Submit', style: AppTheme.button),
                        style: AppTheme.primaryButtonStyle,
                      ),
                    ),
                    const SizedBox(height: AppTheme.space2xl),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return CardRow(
                          index: index,
                          time: data[index]['timeStamp']!,
                          title: data[index]['title']!,
                          content: data[index]['content']!,
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
    Widget timeWidget = Flexible(
      flex: 3,
      child: Container(
        margin: const EdgeInsets.all(AppTheme.spaceSm),
        decoration: AppTheme.cardDecoration.copyWith(
          color: AppTheme.primaryPale.withOpacity(0.3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          child: Center(
            child: Text(
              time,
              style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    Widget contentWidget = Expanded(
      flex: 8,
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
          margin: const EdgeInsets.all(AppTheme.spaceSm),
          decoration: AppTheme.cardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.heading2,
                ),
                SizedBox(height: AppTheme.spaceXs),
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
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: index % 2 == 0
          ? [timeWidget, contentWidget]
          : [contentWidget, timeWidget],
    );
  }
}
