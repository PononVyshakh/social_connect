import 'package:flutter/material.dart';

class OnlineStatusWidget extends StatelessWidget {
  final int count;

  const OnlineStatusWidget({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.circle, color: Colors.green, size: 10),
        const SizedBox(width: 5),
        Text(
          "$count",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(width: 10),
      ],
    );
  }
}