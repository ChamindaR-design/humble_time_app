import 'package:flutter/material.dart';
import 'accessible_text.dart';
import '../services/voice_service.dart';
import '../core/utils/ui_toolkit.dart';

class SessionReflectionForm extends StatelessWidget {
  final Function(String mood, String reflection) onSubmit;
  final UIToolkit toolkit = UIToolkit(); // ✅ non-const initialized instance

  SessionReflectionForm({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final moodController = TextEditingController();
    final reflectionController = TextEditingController();
    final double scaledFont = toolkit.scaledFontSize(context, 16);

    return Container(
      color: toolkit.softBackground(context),
      padding: toolkit.horizontalPadding(context, 2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccessibleText(
            text: 'Mood',
            baseFontSize: scaledFont,
          ),
          TextField(
            controller: moodController,
            style: TextStyle(fontSize: scaledFont),
          ),

          toolkit.verticalSpace(context, 2.0),
          AccessibleText(
            text: 'Session Reflection',
            baseFontSize: scaledFont,
          ),
          TextField(
            controller: reflectionController,
            maxLines: 3,
            style: TextStyle(fontSize: scaledFont),
          ),

          toolkit.verticalSpace(context, 3.0),
          Center(
            child: ElevatedButton(
              onPressed: () {
                VoiceService.speak('Reflection saved. Take a deep breath.');
                onSubmit(moodController.text, reflectionController.text);
              },
              child: Text(
                'Submit',
                style: TextStyle(fontSize: scaledFont),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
