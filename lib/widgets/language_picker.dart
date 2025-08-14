import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:humble_time_app/core/providers/localization_provider.dart';
import 'package:humble_time_app/services/voice_service.dart'; // ✅ Import your VoiceService
import 'package:humble_time_app/l10n/app_localizations.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownButton<Locale>(
      value: currentLocale,
      onChanged: (Locale? newLocale) async {
        if (newLocale != null) {
          ref.read(localeProvider.notifier).state = newLocale;
          await VoiceService.updateLanguageFromLocale(newLocale);

          if (context.mounted) {
            /*final localized = AppLocalizations.of(context);
            await VoiceService.speak(localized?.languageSwitched ?? 'Language changed');*/
            final localized = AppLocalizations.of(context);
            final confirmation = localized?.languageSwitched ?? 'Language changed';
            await VoiceService.speak(confirmation);
          }

          HapticFeedback.selectionClick();
        }
      },
      /*onChanged: (Locale? newLocale) async {
        if (newLocale != null) {
          // 🧠 Update app locale
          ref.read(localeProvider.notifier).state = newLocale;

          // 🔊 Update TTS language
          await VoiceService.updateLanguageFromLocale(newLocale);

          // 🗣️ Speak confirmation
          final label = _labelFor(newLocale.languageCode);
          await VoiceService.speak('Language switched to $label');

          // 📳 Optional haptic feedback
          HapticFeedback.selectionClick();
        }
      },*/
      items: const [
        DropdownMenuItem(
          value: Locale('en'),
          child: Text('English'),
        ),
        DropdownMenuItem(
          value: Locale('si'),
          child: Text('සිංහල'),
        ),
        DropdownMenuItem(
          value: Locale('ja'),
          child: Text('日本語'),
        ),
      ],
    );
  }

/*  /// Maps language codes to readable labels
  String _labelFor(String code) {
    return switch (code) {
      'si' => 'සිංහල',
      'ja' => '日本語',
      'en' => 'English',
      _ => 'Unknown',
    };
  }*/
}
