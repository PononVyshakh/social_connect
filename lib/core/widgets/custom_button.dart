// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/text_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final bool isOutlined;

  const CustomButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? AppDimensions.buttonHeightMedium,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onPressed,
              style: OutlinedButton.styleFrom(
                padding: padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppDimensions.buttonPaddingHorizontal,
                      vertical: AppDimensions.buttonPaddingVertical,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
                side: BorderSide(color: backgroundColor ?? AppColors.primary),
              ),
              child: _buildButtonChild(),
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? AppColors.primary,
                padding: padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppDimensions.buttonPaddingHorizontal,
                      vertical: AppDimensions.buttonPaddingVertical,
                    ),
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
              ),
              child: _buildButtonChild(),
            ),
    );
  }

  Widget _buildButtonChild() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? AppColors.textLight,
          ),
        ),
      );
    }

    return Text(
      label,
      style: TextStyles.labelLarge.copyWith(
        color: isOutlined ? (backgroundColor ?? AppColors.primary) : (textColor ?? AppColors.textLight),
      ),
    );
  }
}
