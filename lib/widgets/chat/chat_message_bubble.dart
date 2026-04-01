import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ChatMessage {
  final String text;
  final bool isMe;
  final String senderName;
  final String senderAvatar;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.senderName,
    required this.senderAvatar,
    required this.timestamp,
  });
}

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.message.isMe 
              ? AppColors.primary.withOpacity(0.3)
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sender name
            Text(
              widget.message.senderName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: widget.message.isMe 
                    ? AppColors.primary
                    : Colors.grey.shade700,
              ),
            ),
            
            const SizedBox(height: 6),
            
            // Message text
            Text(
              widget.message.text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
            
            // Timestamp - only visible on hover/touch
            if (isHovered) ...[
              const SizedBox(height: 6),
              Text(
                _formatTime(widget.message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: widget.message.isMe 
          ? AppColors.primary 
          : AppColors.primary.withOpacity(0.2),
      child: Text(
        widget.message.senderAvatar,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: widget.message.isMe ? Colors.white : AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: widget.message.isMe 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.message.isMe
            ? [
                // For sent messages: Message bubble first, then avatar on right
                Flexible(
                  child: MouseRegion(
                    onEnter: (_) => widget.onHoverEnter(widget.index),
                    onExit: (_) => widget.onHoverExit(widget.index),
                    child: GestureDetector(
                      onTapDown: (_) => widget.onTapDown(widget.index),
                      onTapUp: (_) => widget.onTapUp(widget.index),
                      onTapCancel: () => widget.onHoverExit(widget.index),
                      child: _buildMessageContent(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildAvatar(),
              ]
            : [
                // For received messages: Avatar on left, then message bubble
                _buildAvatar(),
                const SizedBox(width: 12),
                Flexible(
                  child: MouseRegion(
                    onEnter: (_) => widget.onHoverEnter(widget.index),
                    onExit: (_) => widget.onHoverExit(widget.index),
                    child: GestureDetector(
                      onTapDown: (_) => widget.onTapDown(widget.index),
                      onTapUp: (_) => widget.onTapUp(widget.index),
                      onTapCancel: () => widget.onHoverExit(widget.index),
                      child: _buildMessageContent(),
                    ),
                  ),
                ),
              ],
      ),
    );
  }
}
