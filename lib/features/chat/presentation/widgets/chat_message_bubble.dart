// lib/features/chat/presentation/widgets/chat_message_bubble.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../domain/models/message_model.dart';

class ChatMessageBubble extends StatefulWidget {
  final MessageModel message;
  final int index;
  final Set<int> hoveredMessages;
  final Function(int) onHoverEnter;
  final Function(int) onHoverExit;
  final Function(int) onTapDown;
  final Function(int) onTapUp;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.index,
    required this.hoveredMessages,
    required this.onHoverEnter,
    required this.onHoverExit,
    required this.onTapDown,
    required this.onTapUp,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildMessageContent() {
    final isHovered = widget.hoveredMessages.contains(widget.index);
    
    return Container(
      decoration: BoxDecoration(
        color: widget.message.isMe 
            ? AppColors.primary.withOpacity(0.1)
            : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: widget.message.isMe 
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender name
            Text(
              widget.message.senderName,
              style: TextStyles.labelSmall.copyWith(
                color: widget.message.isMe 
                    ? AppColors.primary
                    : AppColors.textMuted,
              ),
            ),
            // Message text
            Text(
              widget.message.text,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textDark,
              ),
            ),
            // Time
            Text(
              _formatTime(widget.message.timestamp),
              style: TextStyles.labelSmall.copyWith(
                color: Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHoverEnter(widget.index),
      onExit: (_) => widget.onHoverExit(widget.index),
      child: GestureDetector(
        onTapDown: (_) => widget.onTapDown(widget.index),
        onTapUp: (_) => widget.onTapUp(widget.index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: widget.message.isMe 
                ? MainAxisAlignment.end 
                : MainAxisAlignment.start,
            children: [
              if (!widget.message.isMe)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      widget.message.senderAvatar ?? 'U',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              Flexible(
                child: _buildMessageContent(),
              ),
              if (widget.message.isMe)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      widget.message.senderAvatar ?? 'U',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
