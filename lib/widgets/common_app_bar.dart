import 'package:flutter/material.dart';
import 'appbar/online_status_widget.dart';
import 'appbar/inbox_icon_widget.dart';
import 'appbar/notification_icon_widget.dart';
import 'appbar/profile_icon_widget.dart';
import 'appbar/menu_widget.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  
  // Optional parameters for customization
  final int onlineCount;
  final int notificationCount;
  final VoidCallback? onInboxTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const CommonAppBar({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.onlineCount = 0,
    this.notificationCount = 0,
    this.onInboxTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'lib/assets/logo.png',
        height: 80,
        width: 245,
      ),
      titleSpacing: showBackButton ? -15 : 0,
      centerTitle: false,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () {
                Navigator.pop(context);
              },
            )
          : null,
      backgroundColor: const Color(0xFF1B4332),
      foregroundColor: const Color(0xFFFAF9F6),
      elevation: 0,
      actions: [
        // Online users count
        OnlineStatusWidget(count: onlineCount),
        
        // Inbox / Chats icon
        InboxIconWidget(
          onTap: onInboxTap ?? () {
            // TODO: Navigate to inbox
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inbox feature coming soon')),
            );
          },
        ),
        
        // Notifications icon with badge
        NotificationIconWidget(
          count: notificationCount,
          onTap: onNotificationTap ?? () {
            // TODO: Show notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
        ),
        
        // Profile icon
        ProfileIconWidget(
          onTap: onProfileTap ?? () {
            // TODO: Navigate to profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile coming soon')),
            );
          },
        ),
        
        // Menu (3 dots)
        const MenuWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}