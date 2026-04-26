// lib/features/home/presentation/widgets/appbar/menu_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/controllers/auth_controller.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Settings'),
        ),
        const PopupMenuItem<String>(
          value: 'help',
          child: Text('Help & Support'),
        ),
        const PopupMenuItem<String>(
          value: 'about',
          child: Text('About'),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: 'logout',
          child: Text('Logout'),
        ),
      ],
      onSelected: (String value) {
        if (value == 'logout') {
          context.read<AuthController>().signOut();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        }
      },
    );
  }
}
