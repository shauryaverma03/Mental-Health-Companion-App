import 'package:flutter/material.dart';
import 'package:saathi/pages/dashboard.dart';
import 'package:saathi/services/chat_service.dart';
import 'package:intl/intl.dart';
import 'package:saathi/themes/app_theme.dart';
import 'package:saathi/widgets/sleeping_panda_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  static String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  List<dynamic> _messages = [];
  bool _isLoading = false;
  bool _isSending = false;
  bool _isPandaSleeping = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
      _isPandaSleeping = false;
    });
    try {
      final messages = await _chatService.getMessages(
          '901bf4b9-caa5-4376-a0ec-d0d450cfe1e5', getFormattedDate());
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isPandaSleeping = true;
      });
    }
  }

  String getFormattedDate() {
    final DateTime now = DateTime.now()
        .subtract(const Duration(hours: 10, minutes: 30));
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  final String _userId = '901bf4b9-caa5-4376-a0ec-d0d450cfe1e5';

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
        appBar: AppTheme.standardAppBar('Chat with Panda'),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: AppTheme.primary),
                        )
                      : _isPandaSleeping
                          ? SleepingPandaWidget(
                              title: "Panda is Sleeping...",
                              message:
                                  "Panda is taking a rest right now! This feature will be updated in the next update. Stay tuned! 🐼💤",
                              onRetry: _fetchMessages,
                              retryButtonText: "Check Again",
                              showUpdateNotice: true,
                            )
                          : ListView.builder(
                              reverse: false,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spaceMd,
                                vertical: AppTheme.spaceLg,
                              ),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                final message = _messages[index];
                                return MessageBubble(
                                  sender: message['sender'] ?? 'Unknown',
                                  text: message['message'] ?? '',
                                  isMe: message['sender'] != 'Pepo',
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          style: AppTheme.body,
                          decoration: InputDecoration(
                            hintText: 'Type your message here...',
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
                      const SizedBox(width: AppTheme.spaceMd),
                      ElevatedButton(
                        onPressed: _isSending
                            ? null
                            : () async {
                                final messageText = _messageController.text.trim();
                                if (messageText.isNotEmpty) {
                                  _messageController.clear();
                                  final userMsg = {
                                    'sender': 'User',
                                    'userId': _userId,
                                    'message': messageText,
                                    'timestamp':
                                        DateTime.now().millisecondsSinceEpoch,
                                  };
                                  setState(() {
                                    _messages.add(userMsg);
                                    _isSending = true;
                                  });
                                  try {
                                    final response = await _chatService.sendMessages(
                                        _userId, messageText);
                                    setState(() {
                                      _messages.add({
                                        'sender': 'Pepo',
                                        'message': response,
                                        'timestamp':
                                            DateTime.now().millisecondsSinceEpoch,
                                      });
                                    });
                                  } catch (e) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Row(
                                            children: [
                                              Icon(Icons.bedtime_rounded, color: Colors.white),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Text("Panda is sleeping! Will be updated in the next update."),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppTheme.primaryDark,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    }
                                  } finally {
                                    if (mounted) {
                                      setState(() {
                                        _isSending = false;
                                      });
                                    }
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          foregroundColor: AppTheme.textOnPrimary,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusPill),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spaceXl,
                            vertical: AppTheme.spaceMd,
                          ),
                        ),
                        child: _isSending
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.textOnPrimary,
                                ),
                              )
                            : const Text(
                                'Send',
                                style: AppTheme.button,
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

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.sender,
    required this.text,
    required this.isMe,
  });

  final String sender, text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceXs, horizontal: AppTheme.spaceXs),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppTheme.spaceSm, right: AppTheme.spaceSm, bottom: 2.0),
            child: Text(
              sender,
              style: AppTheme.bodySmall.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusLg),
                    bottomLeft: Radius.circular(AppTheme.radiusLg),
                    bottomRight: Radius.circular(AppTheme.radiusLg),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(AppTheme.radiusLg),
                    bottomLeft: Radius.circular(AppTheme.radiusLg),
                    bottomRight: Radius.circular(AppTheme.radiusLg),
                  ),
            elevation: 2.0,
            shadowColor: AppTheme.primaryPale,
            color: isMe ? AppTheme.primaryLight : AppTheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spaceMd,
                horizontal: AppTheme.spaceLg,
              ),
              child: Text(
                text,
                style: AppTheme.body.copyWith(
                  color: isMe ? AppTheme.primaryDark : AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
