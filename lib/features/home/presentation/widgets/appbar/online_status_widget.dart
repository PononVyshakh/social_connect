// lib/features/home/presentation/widgets/appbar/online_status_widget.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class OnlineStatusWidget extends StatelessWidget {
  final int count;

  const OnlineStatusWidget({super.key, this.count = 0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Text(
          count > 0 ? '$count online' : '',
          style: TextStyles.labelSmall,
        ),
      ),
    );
  }
}
