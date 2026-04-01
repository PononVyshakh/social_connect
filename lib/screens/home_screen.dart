import 'package:flutter/material.dart';
import 'users_list_screen.dart';
import '../services/session_manager.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/chat_screen_widget.dart';

class HomeScreen extends StatelessWidget {
  final String mobileNumber;
  final String gender;
  
  const HomeScreen({super.key, required this.mobileNumber, required this.gender});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: false),
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
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(28),
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
                        const Text(
                          'Welcome',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FutureBuilder(
                          future: SessionManager.getUserDisplayName(),
                          builder: (context, snapshot) {
                            String displayName = snapshot.data ?? 'User';
                            return Text(
                              displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Color(0xFF7F8C8D),
                                letterSpacing: 0.5,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        Container(
                          height: 1,
                          color: const Color(0xFFE0DED5),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Find meaningful connections',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF1B4332),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Your journey begins here : TAP ANYWHERE...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF95A5A6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}