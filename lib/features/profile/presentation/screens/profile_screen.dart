// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../home/presentation/widgets/appbar/common_app_bar.dart';
import '../widgets/profile_avatar_widget.dart';
import '../widgets/profile_name_tile.dart';
import '../widgets/profile_about_tile.dart';
import '../widgets/profile_gender_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _refreshKey = 0;

  Future<Map<String, dynamic>?> _getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
    return doc.data();
  }

  void _refreshData() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: true),
      body: FutureBuilder<Map<String, dynamic>?>(
        key: ValueKey(_refreshKey),
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user data found'));
          }

          final user = snapshot.data!;
          final displayName = user['displayName'] ?? 'No Name';
          final about = user['about'] ?? '';
          final userGender = user['gender'] ?? 'unknown';

          return Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  ProfileAvatarWidget(radius: 60),
                  const SizedBox(height: 10),
                  ProfileNameTile(
                    name: displayName,
                    onNameChanged: (_) => _refreshData(),
                  ),
                  ProfileGenderTile(
                    gender: userGender,
                    onGenderChanged: (_) => _refreshData(),
                  ),
                  ProfileAboutTile(
                    about: about,
                    onAboutChanged: (_) => _refreshData(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
