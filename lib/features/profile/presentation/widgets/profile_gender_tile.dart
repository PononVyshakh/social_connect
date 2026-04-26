// lib/features/profile/presentation/widgets/profile_gender_tile.dart
import 'package:flutter/material.dart';
import '../screens/edit_gender_screen.dart';

class ProfileGenderTile extends StatelessWidget {
  final String gender;
  final Function(String)? onGenderChanged;

  const ProfileGenderTile({
    super.key,
    required this.gender,
    this.onGenderChanged,
  });

  Future<void> _openEdit(BuildContext context) async {
    final updated = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => EditGenderScreen(currentGender: gender),
      ),
    );

    if (updated != null && onGenderChanged != null) {
      onGenderChanged!(updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.wc),
      title: const Text('Gender'),
      subtitle: Text(gender),
      trailing: const Icon(Icons.edit, size: 18),
      onTap: () => _openEdit(context),
    );
  }
}
