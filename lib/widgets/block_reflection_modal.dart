import 'package:flutter/material.dart';

class BlockReflectionModal extends StatefulWidget {
  final int hour;
  final void Function(String? note, String? mood, String? label) onSave;

  const BlockReflectionModal({
    super.key,
    required this.hour,
    required this.onSave,
  });

  @override
  State<BlockReflectionModal> createState() => _BlockReflectionModalState();
}

class _BlockReflectionModalState extends State<BlockReflectionModal> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedMood;
  String? _selectedLabel;

  final List<String> moods = ['😊', '😐', '😞'];
  final List<String> labels = ['Writing', 'Emails', 'Break', 'Meeting'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Reflect on ${widget.hour}:00', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Reflection',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              items: moods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
              onChanged: (val) => setState(() => _selectedMood = val),
              decoration: const InputDecoration(labelText: 'Mood'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedLabel,
              items: labels.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
              onChanged: (val) => setState(() => _selectedLabel = val),
              decoration: const InputDecoration(labelText: 'Task Label'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
                  _selectedMood,
                  _selectedLabel,
                );
                Navigator.pop(context);
              },
              child: const Text('Save Reflection'),
            ),
          ],
        ),
      ),
    );
  }
}
