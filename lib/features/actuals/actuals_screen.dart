import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:humble_time_app/features/actuals/entry_form.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/core/navigation/bottom_nav_bar.dart';
import 'package:humble_time_app/features/actuals/services/actuals_store.dart';
import 'package:humble_time_app/features/actuals/widgets/actuals_list.dart';

class ActualsScreen extends StatelessWidget {
  const ActualsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ActualsStore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Actuals'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Home',
          onPressed: () {
            HapticFeedback.selectionClick();
            VoiceService.speak("Returning to Home");
            context.go('/');
          },
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
      /*body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Semantics(
              label: 'Log what you have completed so far',
              child: Text(
                "Log what you've completed so far.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            EntryForm(
              onSaved: (text) async {
                await store.addEntry(text);
              },
            ),
            const SizedBox(height: 16),
            // History list (was the red-marked area)
            Expanded(
              child: ActualsList(store: store),
            ),
          ],
        ),
      ),*/
      //Fixing RenderFlex overflowed by 100 pixels on the bottom
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Log what you have completed so far',
              child: Text(
                "Log what you've completed so far.",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 12),
            EntryForm(
              onSaved: (text) async {
                await store.addEntry(text);
              },
            ),
            const SizedBox(height: 16),
            ActualsList(store: store), // ✅ No Expanded
          ],
        ),
      ),
    );
  }
}
