// lib/features/auth/presentation/widgets/phone_input_field.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const PhoneInputField({
    super.key,
    required this.controller,
    this.hintText = '+91 12345 67890',
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: 'Mobile Number',
        labelStyle: TextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        filled: true,
        fillColor: AppColors.white,
        prefixIcon: const Icon(
          Icons.phone,
          color: AppColors.primary,
        ),
        hintText: hintText,
        hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
      ),
    );
  }
}
