// lib/features/home/presentation/widgets/appbar/inbox_icon_widget.dart
import 'package:flutter/material.dart';

class InboxIconWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const InboxIconWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.mail_outline),
      onPressed: onTap,
    );
  }
}
