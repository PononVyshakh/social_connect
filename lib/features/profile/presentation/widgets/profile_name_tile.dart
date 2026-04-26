// lib/features/profile/presentation/widgets/profile_name_tile.dart
import 'package:flutter/material.dart';
import '../screens/edit_name_screen.dart';

class ProfileNameTile extends StatelessWidget {
  final String name;
  final Function(String)? onNameChanged;

  const ProfileNameTile({
    super.key,
    required this.name,
    this.onNameChanged,
  });

  Future<void> _openEdit(BuildContext context) async {
    final updatedName = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditNameScreen(currentName: name),
      ),
    );

    if (updatedName != null && updatedName.isNotEmpty && onNameChanged != null) {
      onNameChanged!(updatedName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: const Text('Name'),
      subtitle: Text(name),
      trailing: const Icon(Icons.edit, size: 18),
      onTap: () => _openEdit(context),
    );
  }
}
