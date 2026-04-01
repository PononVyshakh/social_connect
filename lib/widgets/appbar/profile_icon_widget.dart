import 'package:flutter/material.dart';

class ProfileIconWidget extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileIconWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const CircleAvatar(
        radius: 12,
        backgroundColor: Colors.white,
        child: Icon(Icons.person, size: 16, color: Colors.black),
      ),
      onPressed: onTap,
    );
  }
}