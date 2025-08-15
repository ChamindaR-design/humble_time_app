import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/shared_prefs/save_reflection.dart';

class ReflectionHistoryScreen extends StatefulWidget {
  const ReflectionHistoryScreen({super.key});

  @override
  State<ReflectionHistoryScreen> createState() => _ReflectionHistoryScreenState();
}

class _ReflectionHistoryScreenState extends State<ReflectionHistoryScreen> {
  late Future<List<Reflection>> _reflections;
  late final FlutterTts flutterTts;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _reflections = _safeLoadReflections();
  }

  Future<List<Reflection>> _safeLoadReflections() async {
    try {
      final all = await loadAllReflections();
      return all.where((r) => r.note.isNotEmpty).toList();
    } catch (e) {
      debugPrint('❌ Error loading reflections: $e');
      return [];
    }
  }

  Future<void> _speak(String? text) async {
    if (text == null || text.trim().isEmpty) return;
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflection History'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: FutureBuilder<List<Reflection>>(
        future: _reflections,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading reflections: ${snapshot.error}'));
          }

          final reflections = snapshot.data;
          if (reflections == null || reflections.isEmpty) {
            return const Center(
              child: Text(
                'No valid reflections found.\nYour saved thoughts will appear here.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            itemCount: reflections.length,
            itemBuilder: (context, index) {
              final r = reflections[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Text(_emojiForIntention(r.intention), style: const TextStyle(fontSize: 24)),
                  title: Text(_formatTimestamp(r.timestamp)),
                  subtitle: Text(r.note),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up),
                    tooltip: 'Play reflection',
                    onPressed: () => _speak(r.note),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _emojiForIntention(String intention) {
    const map = {
      'Calm': '😊',
      'Focus': '🧠',
      'Restore': '🌿',
      'Reset': '🔄',
      'Reflect': '🪞',
    };
    return map[intention] ?? '📝';
  }

  String _formatTimestamp(String ts) {
    try {
      final dt = DateTime.parse(ts);
      final date = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
      final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      return '$date • $time';
    } catch (e) {
      debugPrint('⚠️ Failed to parse timestamp: $ts');
      return ts;
    }
  }
}
