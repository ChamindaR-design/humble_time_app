import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/shared_prefs/save_reflection.dart';

class ReflectionHistoryScreen extends StatefulWidget {
  const ReflectionHistoryScreen({super.key});

  @override
  State<ReflectionHistoryScreen> createState() => _ReflectionHistoryScreenState();
}

class _ReflectionHistoryScreenState extends State<ReflectionHistoryScreen> {
  late Future<List<Reflection>> _reflections;

  @override
  void initState() {
    super.initState();
    _reflections = _safeLoadReflections();
  }

  Future<List<Reflection>> _safeLoadReflections() async {
    try {
      final all = await loadAllReflections();
      return all.where((r) => r.note.isNotEmpty).toList(); // Optional filter
    } catch (e) {
      debugPrint('❌ Error loading reflections: $e');
      return [];
    }
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
                'No valid reflections found.\nSome entries may be corrupted or incomplete.',
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
                  leading: Text(
                    _emojiForIntention(r.intention),
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text("${r.timestamp} • Block ${r.block}"),
                  subtitle: Text(r.note),
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
}
