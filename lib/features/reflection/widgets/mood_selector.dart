import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final String? selectedMood;
  final ValueChanged<String> onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  static const List<String> moods = ['😊', '😐', '😕', '😴', '💪'];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: moods.map((emoji) {
        return ChoiceChip(
          label: Text(emoji, style: const TextStyle(fontSize: 24)),
          selected: selectedMood == emoji,
          onSelected: (_) => onMoodSelected(emoji),
          tooltip: _describeMood(emoji),
        );
      }).toList(),
    );
  }

  String _describeMood(String emoji) {
    switch (emoji) {
      case '😊': return 'Content or happy';
      case '😐': return 'Neutral or okay';
      case '😕': return 'Uncertain or distracted';
      case '😴': return 'Tired or low energy';
      case '💪': return 'Focused or empowered';
      default: return 'Mood';
    }
  }
}
