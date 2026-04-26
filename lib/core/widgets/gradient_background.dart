// lib/core/widgets/gradient_background.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Alignment begin;
  final Alignment end;
  final List<Color>? colors;

  const GradientBackground({
    Key? key,
    required this.child,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ?? [
            AppColors.backgroundLight,
            AppColors.backgroundLighter,
          ],
        ),
      ),
      child: child,
    );
  }
}
