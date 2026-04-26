// lib/features/auth/presentation/widgets/gender_selector.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class GenderSelector extends StatefulWidget {
  final ValueChanged<String> onGenderSelected;
  final String? initialGender;

  const GenderSelector({
    super.key,
    required this.onGenderSelected,
    this.initialGender,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender ?? 'unknown';
  }

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
    });
    widget.onGenderSelected(gender);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Select Your Gender',
          style: TextStyles.headlineSmall,
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildGenderButton('Male'),
            _buildGenderButton('Female'),
            _buildGenderButton('Other'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return ElevatedButton(
      onPressed: () => _selectGender(gender),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : AppColors.white,
        foregroundColor: isSelected ? AppColors.textLight : AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.primary,
            width: isSelected ? 0 : 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        gender,
        style: TextStyles.labelLarge.copyWith(
          color: isSelected ? AppColors.textLight : AppColors.primary,
        ),
      ),
    );
  }
}
