import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/pages/post_details.dart';
import 'package:saathi/services/community_service.dart';
import 'package:saathi/themes/app_theme.dart';

import 'package:intl/intl.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});
  static String id = 'community_screen';

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final TextEditingController _controller = TextEditingController();
  List<dynamic> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCommunityMessages();
  }

  Future<void> _fetchCommunityMessages() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final communityService = CommunityService();
      final messages = await communityService.getCommunityMessages();
      setState(() {
        _posts = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Unable to load community messages. Please try again later!';
      });
    }
  }

  String _formatTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  Future<void> _addPost() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      try {
        final communityService = CommunityService();
        await communityService.createCommunityMessage(
            '2afca97e-8c6c-4f08-acee-bc9af7489726', message);
        setState(() {
          _posts.add({
            'userId': 'Anonymous User',
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'message': message,
            'comments': [],
          });
          _controller.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to publish post right now. Please try again!'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: AppTheme.standardAppBar('Community'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : _errorMessage != null
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(AppTheme.spaceLg),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _errorMessage!,
                                      textAlign: TextAlign.center,
                                      style: AppTheme.body.copyWith(color: AppTheme.error),
                                    ),
                                    const SizedBox(height: AppTheme.spaceMd),
                                    ElevatedButton(
                                      onPressed: _fetchCommunityMessages,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primary,
                                        foregroundColor: AppTheme.textOnPrimary,
                                      ),
                                      child: const Text('Retry'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : _posts.isEmpty
                              ? Center(
                                  child: Text(
                                    'No posts yet. Be the first to contribute!',
                                    style: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _posts.length,
                                  itemBuilder: (context, index) {
                                    final post = _posts[index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: AppTheme.spaceSm, horizontal: AppTheme.spaceLg),
                                      decoration: AppTheme.cardDecoration,
                                      child: Padding(
                                        padding: const EdgeInsets.all(AppTheme.spaceMd),
                                        child: ListTile(
                                          title: Text('Anonymous User', style: AppTheme.heading2),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: AppTheme.spaceXs),
                                              Text(
                                                _formatTimestamp(post['timestamp']),
                                                style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                                              ),
                                              const SizedBox(height: AppTheme.spaceSm),
                                              Text(
                                                post['message'],
                                                style: AppTheme.body,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostDetailsPage(post: post),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
                Container(
                  padding: const EdgeInsets.all(AppTheme.spaceMd),
                  decoration: BoxDecoration(
                    color: AppTheme.surface.withOpacity(0.8),
                    border: Border(
                      top: BorderSide(color: AppTheme.primaryLight, width: 1.0),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: AppTheme.body,
                          decoration: InputDecoration(
                            hintText: 'Write a post...',
                            hintStyle: AppTheme.body.copyWith(color: AppTheme.textSecondary),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: AppTheme.spaceLg),
                            filled: true,
                            fillColor: AppTheme.surface,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusPill)),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primaryPale, width: 1.0),
                              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusPill)),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: AppTheme.primary, width: 2.0),
                              borderRadius: BorderRadius.all(Radius.circular(AppTheme.radiusPill)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spaceSm),
                      Container(
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: AppTheme.textOnPrimary),
                          onPressed: _addPost,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
