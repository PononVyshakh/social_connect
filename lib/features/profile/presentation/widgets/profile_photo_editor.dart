// lib/features/profile/presentation/widgets/profile_photo_editor.dart
import 'package:flutter/material.dart';

class ProfilePhotoEditor extends StatelessWidget {
  final VoidCallback? onCameraTap;
  final VoidCallback? onGalleryTap;

  const ProfilePhotoEditor({
    super.key,
    this.onCameraTap,
    this.onGalleryTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Take Photo'),
            onTap: () {
              Navigator.pop(context);
              onCameraTap?.call();
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choose from Gallery'),
            onTap: () {
              Navigator.pop(context);
              onGalleryTap?.call();
            },
          ),
        ],
      ),
    );
  }
}
