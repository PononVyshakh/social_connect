// lib/features/home/presentation/widgets/appbar/common_app_bar.dart
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import 'online_status_widget.dart';
import 'inbox_icon_widget.dart';
import 'notification_icon_widget.dart';
import 'profile_icon_widget.dart';
import 'menu_widget.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;
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
      title: Text(
        'Social Connect',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: false,
      leadingWidth: 50,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: [
        OnlineStatusWidget(count: onlineCount),
        InboxIconWidget(
          onTap: onInboxTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Inbox feature coming soon')),
            );
          },
        ),
        NotificationIconWidget(
          count: notificationCount,
          onTap: onNotificationTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
        ),
        ProfileIconWidget(
          onTap: onProfileTap ?? () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile coming soon')),
            );
          },
        ),
        const MenuWidget(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
