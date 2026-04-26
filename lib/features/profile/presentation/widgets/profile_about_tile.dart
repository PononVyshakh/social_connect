// lib/features/profile/presentation/widgets/profile_about_tile.dart
import 'package:flutter/material.dart';
import '../screens/edit_about_screen.dart';

class ProfileAboutTile extends StatelessWidget {
  final String about;
  final Function(String)? onAboutChanged;

  const ProfileAboutTile({
    super.key,
    required this.about,
    this.onAboutChanged,
  });

  Future<void> _openEdit(BuildContext context) async {
    final updated = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditAboutScreen(currentAbout: about),
      ),
    );

    if (updated != null && onAboutChanged != null) {
      onAboutChanged!(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.description_outlined),
      title: const Text('About'),
      subtitle: Text(about.isEmpty ? 'No bio' : about),
      trailing: const Icon(Icons.edit, size: 18),
      onTap: () => _openEdit(context),
    );
  }
}
