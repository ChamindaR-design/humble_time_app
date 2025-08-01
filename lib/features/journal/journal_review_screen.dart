import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // 🆕 For timestamp formatting

class JournalReviewScreen extends StatefulWidget {
  const JournalReviewScreen({super.key});

  @override
  State<JournalReviewScreen> createState() => _JournalReviewScreenState();
}

class _JournalReviewScreenState extends State<JournalReviewScreen> {
  List<Map<String, dynamic>> _entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('journalEntries') ?? [];

    setState(() {
      _entries =
          stored.map((e) => jsonDecode(e)).cast<Map<String, dynamic>>().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Journal Review")),
      body: _entries.isEmpty
          ? const Center(child: Text('No journal entries found'))
          : ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final formattedDate = DateFormat.yMMMd().add_jm().format(
                  DateTime.parse(entry['timestamp']),
                );

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: Text(entry['mood'], style: const TextStyle(fontSize: 24)),
                    title: Text(entry['text']),
                    subtitle: Text(formattedDate),
                  ),
                );
              },
            ),
    );
  }
}
