import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../services/session_manager.dart';
import '../widgets/common_app_bar.dart';

class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String gender;
  final String? displayName;
  final bool isLogin;
  
  const OtpScreen({super.key, required this.mobileNumber, required this.gender, this.displayName, this.isLogin = false});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'OTP sent to ${widget.mobileNumber}',
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Enter OTP',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: '123456',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String enteredOtp = _otpController.text;
                    
                    if (enteredOtp == '123456') {
                      // Save session
                      String displayName = widget.displayName ?? widget.gender;
                      await SessionManager.saveSession(widget.mobileNumber, widget.gender, displayName);
                      print('Session saved for ${widget.mobileNumber} with gender ${widget.gender}');
                      if (!mounted) return;
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(
                            mobileNumber: widget.mobileNumber,
                            gender: widget.gender,
                          ),
                        ),
                      );
                    } else {
                      // Failure - show error
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invalid OTP. Try 123456')),
                      );
                    }
                  },
                  child: const Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}