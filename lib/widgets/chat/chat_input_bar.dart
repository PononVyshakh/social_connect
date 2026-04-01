import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Function() onSendMessage;
  final Function() onVoiceRecording;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSendMessage,
    required this.onVoiceRecording,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  bool _isTextEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateTextEmptyState);
  }

  void _updateTextEmptyState() {
    setState(() {
      _isTextEmpty = widget.controller.text.trim().isEmpty;
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextEmptyState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F6),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                onSubmitted: (_) => widget.onSendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _isTextEmpty 
                ? widget.onVoiceRecording 
                : widget.onSendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
              ),
              child: Icon(
                _isTextEmpty ? Icons.mic : Icons.send,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
