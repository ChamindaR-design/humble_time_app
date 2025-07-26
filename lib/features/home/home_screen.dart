import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Humble Time Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Log History'),
              onTap: () => Navigator.pushNamed(context, '/log'),
            ),
            // Add more navigation ListTiles here
          ],
        ),
      ),
    );
  }
}
