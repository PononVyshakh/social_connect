// lib/features/chat/presentation/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/loading_overlay.dart';
import '../../../home/presentation/widgets/appbar/common_app_bar.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_message_list.dart';
import '../widgets/chat_input_bar.dart';
import '../../domain/models/message_model.dart';
import '../../../auth/services/auth_service.dart';

class ChatScreenWidget extends StatefulWidget {
  const ChatScreenWidget({super.key});

  @override
  State<ChatScreenWidget> createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  late TextEditingController _messageController;
  late ScrollController _scrollController;
  final Set<int> _hoveredMessages = {};
  String? _currentUserName;
  String? _currentUserId;
  String? _currentUserAvatar;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    _scrollController = ScrollController();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await AuthService.getUserData(user.uid);
        final userName = userData?['displayName'] ?? 'User';
        setState(() {
          _currentUserName = userName;
          _currentUserId = user.uid;
          _currentUserAvatar = (userName as String).isNotEmpty 
              ? (userName.split(' ').length >= 2 
                  ? '${userName.split(' ')[0][0]}${userName.split(' ')[1][0]}'
                  : userName[0])
              : 'U';
          _isLoading = false;
        });
      } else {
        setState(() {
          _currentUserName = 'User';
          _currentUserAvatar = 'U';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _currentUserName = 'User';
        _currentUserAvatar = 'U';
        _isLoading = false;
      });
    }
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final chatController = context.read<ChatController>();
    chatController.sendMessage(
      text: _messageController.text.trim(),
      senderName: _currentUserName ?? 'User',
      senderId: _currentUserId ?? 'unknown',
      senderAvatar: _currentUserAvatar,
    );

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: const CommonAppBar(showBackButton: true),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(
        showBackButton: true,
        onlineCount: 12,
        notificationCount: 3,
      ),
      body: Consumer<ChatController>(
        builder: (context, chatController, child) {
          return LoadingOverlay(
            isLoading: chatController.isLoading,
            child: Column(
              children: [
                Expanded(
                  child: ChatMessageList(
                    messages: chatController.messages,
                    scrollController: _scrollController,
                    onMessageHoverEnter: (index) {
                      setState(() {
                        _hoveredMessages.add(index);
                      });
                    },
                    onMessageHoverExit: (index) {
                      setState(() {
                        _hoveredMessages.remove(index);
                      });
                    },
                    onMessageTapDown: (index) {
                      setState(() {
                        _hoveredMessages.add(index);
                      });
                    },
                    onMessageTapUp: (index) {
                      setState(() {
                        _hoveredMessages.remove(index);
                      });
                    },
                    hoveredMessages: _hoveredMessages,
                  ),
                ),
                ChatInputBar(
                  controller: _messageController,
                  onSendMessage: _handleSendMessage,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
