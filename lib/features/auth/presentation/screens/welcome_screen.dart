// lib/features/auth/presentation/screens/welcome_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/gradient_background.dart';
import '../widgets/phone_input_field.dart';
import '../controllers/auth_controller.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../services/session_manager.dart';
import '../../../../../core/widgets/loading_overlay.dart';

class WelcomeScreen extends StatefulWidget {
  final String? mobile;
  final bool isAlreadyRegistered;

  const WelcomeScreen({
    super.key,
    this.mobile,
    this.isAlreadyRegistered = false,
  });

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final TextEditingController _mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.mobile != null) {
      _mobileController.text = widget.mobile!;
    }
  }

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  Future<void> _handleSendOTP(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    String mobile = _mobileController.text.trim();

    if (!mobile.startsWith('+')) {
      mobile = '+91$mobile';
    }

    final authController = context.read<AuthController>();

    print('DEBUG WelcomeScreen: Calling sendOTP for $mobile');
    final success = await authController.sendOTP(mobile, isLoginFlow: true);

    if (!success) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authController.errorMessage ?? 'Failed to send OTP'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
    // If successful, AuthWrapper will automatically detect pendingPhoneForOtp and show OTP screen
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
        body: widget.isAlreadyRegistered
            ? _buildAlreadyRegistered(context)
            : _buildLoginForm(context),
      ),
    );
  }

  Widget _buildAlreadyRegistered(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Mobile Already Registered',
                style: TextStyles.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                widget.mobile ?? '',
                style: TextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: 40),
              CustomButton(
                label: 'Go to Home',
                onPressed: () async {
                  final gender = await SessionManager.getUserGender();
                  if (!context.mounted) return;
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomeScreen(
                        mobileNumber: widget.mobile ?? '',
                        gender: gender ?? 'unknown',
                      ),
                    ),
                  );
                },
                width: double.infinity,
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Logout',
                onPressed: () async {
                  final authController = context.read<AuthController>();
                  await authController.signOut();
                  if (!context.mounted) return;
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                width: double.infinity,
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return LoadingOverlay(
          isLoading: authController.isLoading,
          message: 'Sending OTP...',
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
                          AppStrings.enterMobile,
                          style: TextStyles.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        PhoneInputField(
                          controller: _mobileController,
                          validator: Validators.validatePhone,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          label: AppStrings.sendOTP,
                          onPressed: () => _handleSendOTP(context),
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
    );
  }
}
