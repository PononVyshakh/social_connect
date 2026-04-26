// lib/features/profile/presentation/screens/edit_gender_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/widgets/custom_button.dart';

class EditGenderScreen extends StatefulWidget {
  final String currentGender;

  const EditGenderScreen({super.key, required this.currentGender});

  @override
  State<EditGenderScreen> createState() => _EditGenderScreenState();
}

class _EditGenderScreenState extends State<EditGenderScreen> {
  late String _selectedGender;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.currentGender;
  }

  Future<void> _saveGender() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'gender': _selectedGender});

      if (!mounted) return;
      Navigator.pop(context, _selectedGender);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update gender')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _buildGenderButton(String gender) {
    final isSelected = _selectedGender == gender;
    return ElevatedButton(
      onPressed: () => setState(() => _selectedGender = gender),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : AppColors.white,
        foregroundColor: isSelected ? AppColors.textLight : AppColors.primary,
        side: BorderSide(
          color: AppColors.primary,
          width: isSelected ? 0 : 2,
        ),
      ),
      child: Text(gender),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Gender')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Select Your Gender', style: TextStyles.headlineSmall),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGenderButton('Male'),
                _buildGenderButton('Female'),
                _buildGenderButton('Other'),
              ],
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: _isSaving ? 'Saving...' : 'Save',
              onPressed: _isSaving ? () {} : _saveGender,
              isLoading: _isSaving,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
