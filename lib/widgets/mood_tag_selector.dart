import 'package:flutter/material.dart';

class MoodTagSelector extends StatelessWidget {
  final String selectedMood;
  final ValueChanged<String?> onMoodChanged;

  const MoodTagSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedMood,
      items: ['Happy', 'Neutral', 'Sad'].map((mood) {
        return DropdownMenuItem(
          value: mood,
          child: Text("Mood: $mood"),
        );
      }).toList(),
      onChanged: onMoodChanged,
    );
  }
}
