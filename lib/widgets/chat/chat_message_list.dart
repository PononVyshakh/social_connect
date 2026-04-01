import 'package:flutter/material.dart';
import 'chat_message_bubble.dart';
import 'chat_empty_state.dart';

class ChatMessageList extends StatefulWidget {
  final List<ChatMessage> messages;
  final ScrollController scrollController;
  final Function(int) onMessageHoverEnter;
  final Function(int) onMessageHoverExit;
  final Function(int) onMessageTapDown;
  final Function(int) onMessageTapUp;
  final Set<int> hoveredMessages;

  const ChatMessageList({
    super.key,
    required this.messages,
    required this.scrollController,
    required this.onMessageHoverEnter,
    required this.onMessageHoverExit,
    required this.onMessageTapDown,
    required this.onMessageTapUp,
    required this.hoveredMessages,
  });

  @override
  State<ChatMessageList> createState() => _ChatMessageListState();
}

class _ChatMessageListState extends State<ChatMessageList> {
  @override
  Widget build(BuildContext context) {
    return widget.messages.isEmpty
        ? const ChatEmptyState()
        : ListView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (context, index) {
              final message = widget.messages[index];
              
              return ChatMessageBubble(
                message: message,
                index: index,
                hoveredMessages: widget.hoveredMessages,
                onHoverEnter: widget.onMessageHoverEnter,
                onHoverExit: widget.onMessageHoverExit,
                onTapDown: widget.onMessageTapDown,
                onTapUp: widget.onMessageTapUp,
              );
            },
          );
  }
}
