// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../auth/services/auth_service.dart';
import '../widgets/appbar/common_app_bar.dart';
import '../../../chat/presentation/screens/chat_screen.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/widgets/gradient_background.dart';

class HomeScreen extends StatelessWidget {
  final String? mobileNumber;
  final String? gender;
  
  const HomeScreen({super.key, this.mobileNumber, this.gender});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CommonAppBar(showBackButton: false),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundLight,
                AppColors.backgroundLighter,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [              
                // Welcome card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatScreenWidget(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome',
                            style: TextStyles.headlineXLarge.copyWith(
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Load user data from Firestore
                          FutureBuilder(
                            future: AuthService.getUserData(user?.uid ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              
                              if (snapshot.hasError) {
                                return Text(
                                  'User',
                                  style: TextStyles.bodyMedium.copyWith(
                                    color: AppColors.textMuted,
                                  ),
                                );
                              }
                              
                              final userData = snapshot.data;
                              String displayName = userData?['displayName'] ?? 'User';
                              
                              return Text(
                                displayName,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.5,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Start chatting with people around you',
                            textAlign: TextAlign.center,
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ChatScreenWidget(),
                                ),
                              );
                            },
                            child: const Text('Start Chatting'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
