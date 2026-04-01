import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == "logout") {
          // TODO: Handle logout
        } else if (value == "settings") {
          // TODO: Navigate to settings
        } else if (value == "help") {
          // TODO: Show help
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: "settings", child: Text("Settings")),
        const PopupMenuItem(value: "help", child: Text("Help")),
        const PopupMenuItem(value: "logout", child: Text("Logout")),
      ],
    );
  }
}