import 'package:flutter/material.dart';

class InboxIconWidget extends StatelessWidget {
  final VoidCallback onTap;

  const InboxIconWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.chat_bubble_outline),
      onPressed: onTap,
    );
  }
}