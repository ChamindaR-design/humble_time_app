import 'package:flutter/material.dart';

class PromptBubble extends StatelessWidget {
  final VoidCallback onReplay;

  const PromptBubble({super.key, required this.onReplay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.spa, color: Colors.green[900]),
          const SizedBox(width: 8),
          const Expanded(child: Text("What made you smile today?")),
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: onReplay,
          ),
        ],
      ),
    );
  }
}
