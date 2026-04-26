// lib/features/auth/presentation/screens/auth_wrapper.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../../../../../core/widgets/loading_overlay.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/gradient_background.dart';
import 'welcome_screen.dart';
import 'otp_screen.dart';
import 'register_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  Future<Map<String, dynamic>?>? _cachedUserDataFuture;
  bool _previousIsLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        // Invalidate cache when registration completes (isLoading goes from true to false)
        if (_previousIsLoading && !authController.isLoading) {
          _cachedUserDataFuture = null;
        }
        _previousIsLoading = authController.isLoading;

        // Check if OTP was sent and we're waiting for OTP entry
        if (authController.pendingPhoneForOtp != null) {
          print('DEBUG AuthWrapper: Showing OTP screen for ${authController.pendingPhoneForOtp}');
          return OtpScreen(
            mobileNumber: authController.pendingPhoneForOtp!,
            gender: 'unknown',
            isLogin: authController.isLoginFlow,
          );
        }

        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return GradientBackground(
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
              );
            }

            final user = snapshot.data;

            // Not authenticated
            if (user == null) {
              _cachedUserDataFuture = null;
              return const WelcomeScreen();
            }

            // Authenticated - load combined user check and data
            _cachedUserDataFuture ??= authController.loadUserDataWithCheck(user.uid);

            return FutureBuilder<Map<String, dynamic>?>(
              future: _cachedUserDataFuture,
              builder: (context, userDataSnapshot) {
                if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                  return GradientBackground(
                    child: Scaffold(
                      backgroundColor: Colors.transparent,
                      body: const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary),
                        ),
                      ),
                    ),
                  );
                }

                // Check for errors
                if (userDataSnapshot.hasError) {
                  return RegisterScreen(
                    gender: 'unknown',
                    mobileNumber: user.phoneNumber ?? '',
                  );
                }

                final userData = userDataSnapshot.data;
                
                // No data means new user
                if (userData == null) {
                  return RegisterScreen(
                    gender: 'unknown',
                    mobileNumber: user.phoneNumber ?? '',
                  );
                }

                final gender = userData['gender'] ?? 'unknown';
                final mobileNumber = userData['mobile'] ?? '';

                return HomeScreen(
                  mobileNumber: mobileNumber,
                  gender: gender,
                );
              },
            );
          },
        );
      },
    );
  }
}
