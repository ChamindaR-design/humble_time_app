import 'package:flutter/material.dart';
import 'package:humble_time_app/features/actuals/entry_form.dart';

class ActualsScreen extends StatelessWidget {
  const ActualsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Actuals'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Log what you've completed so far.",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            EntryForm(), // Modular widget for input + save + voice
          ],
        ),
      ),
    );
  }
}
