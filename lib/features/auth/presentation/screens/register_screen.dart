// lib/features/auth/presentation/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/gradient_background.dart';
import '../../../../../core/routes/route_names.dart';
import '../widgets/phone_input_field.dart';
import '../widgets/gender_selector.dart';
import '../controllers/auth_controller.dart';
import '../../../../../core/widgets/loading_overlay.dart';

class RegisterScreen extends StatefulWidget {
  final String gender;
  final String? mobileNumber;

  const RegisterScreen({
    super.key,
    required this.gender,
    this.mobileNumber,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    if (widget.mobileNumber != null) {
      _mobileController.text = widget.mobileNumber!;
    }
    _selectedGender = widget.gender;
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String mobile = _mobileController.text.trim();
    String displayName = _displayNameController.text.trim();

    // Ensure gender is selected
    if (_selectedGender == 'unknown') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender')),
      );
      return;
    }

    // Format mobile with +91
    if (!mobile.startsWith('+')) {
      mobile = '+91$mobile';
    }

    if (!context.mounted) return;
    final authController = context.read<AuthController>();
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication failed')),
      );
      return;
    }

    // Register user
    final success = await authController.registerUser(
      uid: user.uid,
      mobileNumber: mobile,
      displayName: displayName,
      gender: _selectedGender,
    );

    if (!context.mounted) return;

    if (success) {
      if (!context.mounted) return;
      // Clear the form and error
      _mobileController.clear();
      _displayNameController.clear();
      authController.clearError();
      // AuthWrapper will rebuild and detect user now exists via loadUserDataWithCheck
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.errorMessage ?? 'Registration failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            AppStrings.appName,
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textLight),
          ),
        ),
        body: Consumer<AuthController>(
          builder: (context, authController, child) {
            return LoadingOverlay(
              isLoading: authController.isLoading,
              message: 'Creating profile...',
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppStrings.register,
                              style: TextStyles.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            // Phone input
                            PhoneInputField(
                              controller: _mobileController,
                              validator: Validators.validatePhone,
                            ),
                            const SizedBox(height: 20),
                            // Name input
                            TextFormField(
                              controller: _displayNameController,
                              validator: Validators.validateName,
                              decoration: InputDecoration(
                                labelText: AppStrings.enterName,
                                labelStyle: TextStyles.bodyMedium
                                    .copyWith(color: AppColors.textMuted),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.primary),
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                hintText: 'John Doe',
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Gender selector
                            GenderSelector(
                              initialGender: _selectedGender,
                              onGenderSelected: (gender) {
                                setState(() {
                                  _selectedGender = gender;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                            // Register button
                            CustomButton(
                              label: AppStrings.register,
                              onPressed: () => _handleSubmit(context),
                              isLoading: authController.isLoading,
                              width: double.infinity,
                            ),
                            if (authController.errorMessage != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                authController.errorMessage!,
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.error,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
