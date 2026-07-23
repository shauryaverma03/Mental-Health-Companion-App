import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:saathi/services/community_service.dart';
import 'package:saathi/themes/app_theme.dart';

class PostDetailsPage extends StatefulWidget {
  final Map<String, dynamic> post;

  PostDetailsPage({required this.post});

  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        widget.post['comments'].add({
          'userId': 'Anonymous', // Replace with actual user ID if available
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'comment': _commentController.text,
        });
        _commentController.clear();
      });
    }
  }

  void _showReportModal(BuildContext context) {
    String selectedReason = 'Spam';
    final List<String> reasons = ['Spam', 'Harassment', 'Inappropriate content', 'Other'];

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      backgroundColor: AppTheme.surface,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Report Post',
                    style: AppTheme.heading1,
                  ),
                  SizedBox(height: AppTheme.spaceMd),
                  Text('Why are you reporting this post?', style: AppTheme.body),
                  SizedBox(height: AppTheme.spaceMd),
                  DropdownButtonFormField<String>(
                    value: selectedReason,
                    items: reasons.map((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason, style: AppTheme.body),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setModalState(() {
                          selectedReason = newValue;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppTheme.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        borderSide: BorderSide(color: AppTheme.primaryPale, width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        borderSide: BorderSide(color: AppTheme.primaryPale, width: 1.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: AppTheme.spaceMd),
                    ),
                  ),
                  SizedBox(height: AppTheme.spaceXl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Using a generic ID since post structure isn't fully defined
                        String postId = widget.post['_id'] ?? widget.post['timestamp'].toString();
                        CommunityService().reportPost(postId, selectedReason, widget.post['message']);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Post reported. Thank you.'),
                            backgroundColor: AppTheme.primaryDark,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.error,
                        foregroundColor: AppTheme.textOnPrimary,
                        padding: EdgeInsets.symmetric(vertical: AppTheme.spaceMd),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                        ),
                      ),
                      child: Text('Submit Report', style: AppTheme.button),
                    ),
                  ),
                  SizedBox(height: AppTheme.spaceMd),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details', style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: AppTheme.primaryDark),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(
              bottom: BorderSide(color: AppTheme.primaryLight, width: 1.0),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.report_problem_outlined, color: AppTheme.error),
            onPressed: () {
              _showReportModal(context);
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.primaryPale,
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryDark.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Anonymous User",
                      style: AppTheme.heading2,
                    ),
                    SizedBox(height: AppTheme.spaceXs),
                    Text(
                      '${_formatTimestamp(widget.post['timestamp'])}',
                      style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                    ),
                    const SizedBox(height: AppTheme.spaceMd),
                    Text(
                      widget.post['message'] ?? 'No Content',
                      style: AppTheme.body,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              child: Text(
                'Comments',
                style: AppTheme.heading2.copyWith(color: AppTheme.primaryDark),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.spaceLg),
                itemCount: widget.post['comments'].length,
                itemBuilder: (context, index) {
                  final comment = widget.post['comments'][index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.spaceSm),
                    decoration: AppTheme.cardDecoration,
                    child: Padding(
                      padding: const EdgeInsets.all(AppTheme.spaceMd),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            child: Text("A", style: TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold)),
                            backgroundColor: AppTheme.primaryLight,
                          ),
                          SizedBox(width: AppTheme.spaceMd),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Anonymous User",
                                    style: AppTheme.heading3),
                                SizedBox(height: AppTheme.spaceXs),
                                Text(
                                  _formatTimestamp(comment['timestamp']),
                                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                                ),
                                SizedBox(height: AppTheme.spaceSm),
                                Text(comment['comment'], style: AppTheme.body),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppTheme.spaceMd),
              decoration: BoxDecoration(
                color: AppTheme.surface.withOpacity(0.9),
                border: Border(
                  top: BorderSide(color: AppTheme.primaryLight, width: 1.0),
                ),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        style: AppTheme.body,
                        decoration: InputDecoration(
                          hintText: 'Write a comment...',
                          hintStyle: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                          filled: true,
                          fillColor: AppTheme.background,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            borderSide: BorderSide(color: AppTheme.primaryPale, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                            borderSide: BorderSide(color: AppTheme.primary, width: 2.0),
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spaceSm),
                    ElevatedButton(
                      onPressed: _addComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark,
                        foregroundColor: AppTheme.textOnPrimary,
                        padding: EdgeInsets.symmetric(horizontal: AppTheme.spaceLg, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                        ),
                      ),
                      child: Text('Post', style: AppTheme.button),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Comment {
  final String commenter;
  final String content;

  Comment({required this.commenter, required this.content});
}
