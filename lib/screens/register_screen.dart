import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'login_screen.dart';
import '../services/session_manager.dart';
import '../widgets/common_app_bar.dart';

class RegisterScreen extends StatefulWidget {
    final String gender;

    const RegisterScreen({super.key, required this.gender});

    @override
    State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
    final TextEditingController _mobileController = TextEditingController();
    final TextEditingController _displayNameController = TextEditingController();

    @override
    void dispose() {
        _mobileController.dispose();
        _displayNameController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: const CommonAppBar(),
            body: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                            Color(0xFFF8F7F3),
                            Color(0xFFE8E6DD),
                        ],
                    ),
                ),
                child: Center(
                    child: SingleChildScrollView(
                        child: Container(
                            width: 350,
                            margin: const EdgeInsets.all(24),
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
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
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    const Icon(
                                        Icons.phone_android,
                                        size: 48,
                                        color: Color(0xFF1B4332),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                        'Get Started',
                                        style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xFF1B4332),
                                        ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                        width: 50,
                                        height: 2,
                                        color: const Color(0xFFD4A574),
                                    ),
                                    const SizedBox(height: 32),
                                    TextField(
                                        controller: _displayNameController,
                                        decoration: InputDecoration(
                                            labelText: 'Display Name',
                                            labelStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF0EFEA),
                                            prefixIcon: const Icon(
                                                Icons.person,
                                                color: Color(0xFF1B4332),
                                            ),
                                        ),
                                    ),
                                    const SizedBox(height: 16),
                                    TextField(
                                        controller: _mobileController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            labelText: 'Mobile Number',
                                            
                                            labelStyle: const TextStyle(color: Color(0xFF7F8C8D)),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                borderSide: BorderSide.none,
                                            ),
                                            filled: true,
                                            fillColor: const Color(0xFFF0EFEA),
                                            prefixIcon: const Icon(
                                                Icons.phone,
                                                color: Color(0xFF1B4332),
                                            ),
                                            hintText: '+91 12345 67890',
                                        ),
                                    ),
                                    const SizedBox(height: 32),
                                    SizedBox(
                                        width: 200,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                                String mobile = _mobileController.text;
                                                String displayName = _displayNameController.text;

                                                if (mobile.isEmpty) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                            content: Text('Please enter mobile number'),
                                                        ),
                                                    );
                                                    return;
                                                }

                                                if (displayName.isEmpty) {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        const SnackBar(
                                                            content: Text('Please enter display name'),
                                                        ),
                                                    );
                                                    return;
                                                }

                                                bool isRegistered =
                                                    await SessionManager.isMobileRegistered(mobile);

                                                if (isRegistered) {
                                                    if (!mounted) return;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) => LoginScreen(
                                                                mobile: mobile,
                                                                isAlreadyRegistered: true,
                                                            ),
                                                        ),
                                                    );
                                                    return;
                                                }

                                                if (!mounted) return;
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => OtpScreen(
                                                            mobileNumber: mobile,
                                                            gender: widget.gender,
                                                            displayName: displayName,
                                                            isLogin: false,
                                                        ),
                                                    ),
                                                );
                                            },
                                            style: ElevatedButton.styleFrom(
                                                minimumSize: const Size(200, 45),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                ),
                                            ),
                                            child: const Text(
                                                'Send OTP',
                                                style: TextStyle(fontSize: 16),
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}