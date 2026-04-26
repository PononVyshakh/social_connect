// lib/features/auth/presentation/screens/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/gradient_background.dart';
import '../../../../../core/routes/route_names.dart';
import '../controllers/auth_controller.dart';
import '../../../../../core/widgets/loading_overlay.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String gender;
  final String? displayName;
  final bool isLogin;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.gender,
    this.displayName,
    this.isLogin = false,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOTP(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String otp = _otpController.text.trim();

    if (!context.mounted) return;
    final authController = context.read<AuthController>();

    final success = await authController.verifyOTP(otp);

    if (!context.mounted) return;

    if (success) {
      // OTP verified successfully
      // Clear pending OTP state so we don't show this screen again
      authController.clearPendingOtp();
      
      // AuthWrapper will automatically handle routing:
      // - If user exists: shows HomeScreen  
      // - If new user: shows RegisterScreen
      // Just clear the form and return
      _otpController.clear();
      return;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.errorMessage ?? 'Failed to verify OTP'),
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
              message: 'Verifying OTP...',
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
                              AppStrings.enterOTP,
                              style: TextStyles.headlineSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'OTP sent to ${widget.mobileNumber}',
                              style: TextStyles.bodyMedium
                                  .copyWith(color: AppColors.textMuted),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              validator: Validators.validateOTP,
                              decoration: InputDecoration(
                                labelText: 'OTP',
                                labelStyle: TextStyles.bodyMedium
                                    .copyWith(color: AppColors.textMuted),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: AppColors.primary),
                                ),
                                filled: true,
                                fillColor: AppColors.white,
                                hintText: '123456',
                                hintStyle: TextStyles.bodyMedium
                                    .copyWith(color: AppColors.textMuted),
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomButton(
                              label: AppStrings.verifyOTP,
                              onPressed: () => _handleVerifyOTP(context),
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
