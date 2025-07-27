import 'package:flutter/material.dart';

class SessionReflectionForm extends StatelessWidget {
  final Function(String mood, String reflection) onSubmit;

  const SessionReflectionForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final moodController = TextEditingController();
    final reflectionController = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mood'),
        TextField(controller: moodController),

        SizedBox(height: 16),
        Text('Session Reflection'),
        TextField(
          controller: reflectionController,
          maxLines: 3,
        ),

        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onSubmit(moodController.text, reflectionController.text);
          },
          child: Text('Submit'),
        ),
      ],
    );
  }
}
