import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_colors.dart';
import '../widgets/common_app_bar.dart';
import '../services/session_manager.dart';
import './chat/chat_message_bubble.dart';
import './chat/chat_message_list.dart';
import './chat/chat_input_bar.dart';
import './chat/chat_empty_state.dart';

class ChatData extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  void sendMessage(String text, String senderName, String senderAvatar) {
    if (text.trim().isEmpty) return;
    _messages.add(ChatMessage(
      text: text,
      isMe: true,
      senderName: senderName,
      senderAvatar: senderAvatar,
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }
}

class ChatScreenWidget extends StatefulWidget {
  const ChatScreenWidget({super.key});

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  String? _currentUserName;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final userName = await SessionManager.getUserDisplayName();
      setState(() {
        _currentUserName = userName ?? 'User';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _currentUserName = 'User';
        _isLoading = false;
      });
    }
  }

  String _getUserAvatar() {
    if (_currentUserName == null || _currentUserName == 'User') return 'U';
    final nameParts = _currentUserName!.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return _currentUserName![0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => ChatData(),
      child: Scaffold(
        appBar: CommonAppBar(
          showBackButton: true,
          onlineCount: 12,
          notificationCount: 3,
          onInboxTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening inbox...')),
            );
          },
          onNotificationTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening notifications...')),
            );
          },
          onProfileTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Opening profile...')),
            );
          },
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 500, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ChatConsole(
                currentUserName: _currentUserName!,
                currentUserAvatar: _getUserAvatar(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChatConsole extends StatefulWidget {
  final String currentUserName;
  final String currentUserAvatar;

  const ChatConsole({
    super.key,
    required this.currentUserName,
    required this.currentUserAvatar,
  });

  @override
  State<ChatConsole> createState() => _ChatConsoleState();
}

class _ChatConsoleState extends State<ChatConsole> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTextEmpty = true;
  final Set<int> _hoveredMessages = {};

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final chatData = context.read<ChatData>();
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    chatData.sendMessage(
      text,
      widget.currentUserName,
      widget.currentUserAvatar,
    );
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startVoiceRecording() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice recording coming soon...')),
    );
  }

  void _handleMessageHoverEnter(int index) {
    setState(() => _hoveredMessages.add(index));
  }

  void _handleMessageHoverExit(int index) {
    setState(() => _hoveredMessages.remove(index));
  }

  void _handleMessageTapDown(int index) {
    setState(() => _hoveredMessages.add(index));
  }

  void _handleMessageTapUp(int index) {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => _hoveredMessages.remove(index));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatData>().messages;

    return Column(
      children: [
        Expanded(
          child: ChatMessageList(
            messages: messages,
            scrollController: _scrollController,
            onMessageHoverEnter: _handleMessageHoverEnter,
            onMessageHoverExit: _handleMessageHoverExit,
            onMessageTapDown: _handleMessageTapDown,
            onMessageTapUp: _handleMessageTapUp,
            hoveredMessages: _hoveredMessages,
          ),
        ),
        ChatInputBar(
          controller: _controller,
          onSendMessage: _sendMessage,
          onVoiceRecording: _startVoiceRecording,
        ),
      ],
    );
  }
}