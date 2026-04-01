import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'home_screen.dart';
import '../services/session_manager.dart';
import '../widgets/common_app_bar.dart';

class LoginScreen extends StatefulWidget {
  final String? mobile;
  final bool isAlreadyRegistered;
  
  const LoginScreen({super.key, this.mobile, this.isAlreadyRegistered = false});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: Center(
        child: SizedBox(
          width: 350,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: widget.isAlreadyRegistered
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Color(0xFF1B4332),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Mobile Already Registered',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B4332),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.mobile ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          String? savedGender = await SessionManager.getUserGender();
                          if (!mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(
                                mobileNumber: widget.mobile ?? '',
                                gender: savedGender ?? 'unknown',
                              ),
                            ),
                          );
                        },
                        child: const Text('Go to Home'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () async {
                          await SessionManager.logout();
                          if (!mounted) return;
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text('Delete Account'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login with Mobile Number',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: '+91 12345 67890',
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String mobile = _mobileController.text;
                          if (mobile.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter mobile number')),
                            );
                            return;
                          }
                          
                          // Check if user exists
                          bool isRegistered = await SessionManager.isMobileRegistered(mobile);
                          
                          if (!isRegistered) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Mobile number not registered. Please register first.')),
                            );
                            return;
                          }
                          
                          // Get saved gender
                          String? savedGender = await SessionManager.getUserGender();
                          
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(
                                mobileNumber: mobile,
                                gender: savedGender ?? 'unknown',
                                isLogin: true,
                              ),
                            ),
                          );
                        },
                        child: const Text('Send OTP'),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}