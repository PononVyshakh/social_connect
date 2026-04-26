// lib/features/chat/presentation/screens/users_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';
import '../../../home/presentation/widgets/appbar/common_app_bar.dart';
import '../../services/chat_service.dart';
import '../controllers/chat_controller.dart';
import 'chat_screen.dart';
import '../../../auth/services/session_manager.dart';

class UsersListScreen extends StatefulWidget {
  final String currentUserGender;

  const UsersListScreen({
    super.key,
    this.currentUserGender = 'unknown',
  });

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  // Mock users data
  final List<Map<String, String>> _allUsers = [
    {'name': 'Rahul', 'mobile': '9876543210', 'gender': 'male', 'status': 'online'},
    {'name': 'Priya', 'mobile': '9876543211', 'gender': 'female', 'status': 'online'},
    {'name': 'Amit', 'mobile': '9876543212', 'gender': 'male', 'status': 'offline'},
    {'name': 'Neha', 'mobile': '9876543213', 'gender': 'female', 'status': 'online'},
    {'name': 'Vikram', 'mobile': '9876543214', 'gender': 'male', 'status': 'offline'},
    {'name': 'Anjali', 'mobile': '9876543215', 'gender': 'female', 'status': 'online'},
  ];

  List<Map<String, String>> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndFilter();
  }

  Future<void> _loadCurrentUserAndFilter() async {
    // Get current user's display name and mobile
    String? currentUserName = await SessionManager.getUserDisplayName();
    String? currentUserMobile = await SessionManager.getUserMobile();
    String? currentGender = await SessionManager.getUserGender();
    
    // Filter users by opposite gender
    String oppositeGender = (currentGender ?? widget.currentUserGender) == 'male' 
        ? 'female' 
        : 'male';
    
    _filteredUsers = _allUsers
        .where((user) => user['gender'] == oppositeGender)
        .toList();
    
    // Add current user at the beginning with online status
    if (currentUserName != null && currentUserMobile != null) {
      _filteredUsers.insert(0, {
        'name': currentUserName,
        'mobile': currentUserMobile,
        'gender': currentGender ?? widget.currentUserGender,
        'status': 'online',
      });
    }
    
    setState(() {});
  }

  String _getInitials(String name) {
    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(showBackButton: true),
      body: ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          final isOnline = user['status'] == 'online';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    radius: 24,
                    child: Text(
                      _getInitials(user['name']!),
                      style: TextStyles.labelLarge.copyWith(
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isOnline ? Colors.green : Colors.grey,
                        border: Border.all(
                          color: AppColors.white,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                user['name']!,
                style: TextStyles.titleMedium,
              ),
              subtitle: Text(
                user['mobile']!,
                style: TextStyles.bodySmall,
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isOnline 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isOnline ? 'Online' : 'Offline',
                  style: TextStyles.labelSmall.copyWith(
                    color: isOnline ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              onTap: () {
                // Open chat with this user
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreenWidget(),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
