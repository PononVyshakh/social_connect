import 'package:flutter/material.dart';
import 'screens/register_screen.dart';
import 'screens/login_screen.dart';
import 'widgets/common_app_bar.dart';

void main() {
  runApp(const SocialConnectApp());
}

class SocialConnectApp extends StatelessWidget {
  const SocialConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Connect',
      theme: ThemeData(
        primaryColor: const Color(0xFF1B4332),
        scaffoldBackgroundColor: const Color(0xFFF8F7F3),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1B4332),
          foregroundColor: Color(0xFFFAF9F6),
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B4332),
            foregroundColor: const Color(0xFFD4A574),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF2C2C2C)),
          headlineSmall: TextStyle(color: Color(0xFF2C2C2C)),
        ),
      ),
      home: const UserTypeScreen(),
    );
  }
}

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Select Your Gender',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(gender: 'female'),
                  ),
                );
              },
              child: const Text('Female'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterScreen(gender: 'male'),
                  ),
                );
              },
              child: const Text('Male'),
            ),
          ],
        ),
      ),
    );
  }
}