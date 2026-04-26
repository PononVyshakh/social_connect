// lib/features/profile/presentation/screens/edit_about_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../core/widgets/custom_button.dart';

class EditAboutScreen extends StatefulWidget {
  final String currentAbout;

  const EditAboutScreen({super.key, required this.currentAbout});

  @override
  State<EditAboutScreen> createState() => _EditAboutScreenState();
}

class _EditAboutScreenState extends State<EditAboutScreen> {
  late TextEditingController _controller;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentAbout);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveAbout() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final newAbout = _controller.text.trim();

    if (uid == null) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'about': newAbout});

      if (!mounted) return;
      Navigator.pop(context, newAbout);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update about')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit About')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              maxLength: 250,
              decoration: InputDecoration(
                labelText: 'About You',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Tell us about yourself...',
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              label: _isSaving ? 'Saving...' : 'Save',
              onPressed: _isSaving ? () {} : _saveAbout,
              isLoading: _isSaving,
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}
