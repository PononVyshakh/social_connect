// lib/features/home/presentation/widgets/appbar/profile_icon_widget.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';

class ProfileIconWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final double radius;
  final double iconSize;

  const ProfileIconWidget({
    super.key,
    this.onTap,
    this.radius = 16,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.accent,
        child: Icon(
          Icons.person,
          size: iconSize,
          color: Colors.white,
        ),
      ),
      onPressed: onTap,
    );
  }
}
