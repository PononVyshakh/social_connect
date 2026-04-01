import 'package:flutter/material.dart';
import '../services/session_manager.dart';
import '../widgets/common_app_bar.dart';

class UsersListScreen extends StatefulWidget 
{
  final String currentUserGender;
  
  const UsersListScreen({super.key, required this.currentUserGender});

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
    // Get current user's display name
    String? currentUserName = await SessionManager.getUserDisplayName();
    String? currentUserMobile = await SessionManager.getUserMobile();
    
    // Filter users by opposite gender
    String oppositeGender = widget.currentUserGender == 'male' ? 'female' : 'male';
    _filteredUsers = _allUsers.where((user) => user['gender'] == oppositeGender).toList();
    
    // Add current user at the beginning with online status
    if (currentUserName != null && currentUserMobile != null) {
      _filteredUsers.insert(0, {
        'name': currentUserName,
        'mobile': currentUserMobile,
        'gender': widget.currentUserGender,
        'status': 'online',
      });
    }
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),
      body: ListView.builder(
        itemCount: _filteredUsers.length,
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF1B4332),
                child: Text(
                  user['name']![0],
                  style: const TextStyle(color: Color(0xFFD4A574)),
                ),
              ),
              title: Text(user['name']!),
              subtitle: Text(user['mobile']!),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: user['status'] == 'online' 
                      ? Colors.green.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  user['status']!,
                  style: TextStyle(
                    color: user['status'] == 'online' ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () {
                // Will add profile view later
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tapped on ${user['name']}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}