import 'package:flutter/material.dart';

class PacingScreen extends StatelessWidget {
  const PacingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacing Support'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Let's find a pace that works for you.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "This section will help you structure time gently — one step, one block at a time.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Center(
              child: Icon(Icons.timer_outlined, size: 64, color: Colors.indigo),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                "Pacing tools coming soon...",
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
