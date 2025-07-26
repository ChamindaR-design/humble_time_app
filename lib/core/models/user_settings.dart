class UserSettings {
  final double ttsSpeed;
  final bool useDarkMode;
  final String preferredLanguage;

  UserSettings({
    required this.ttsSpeed,
    required this.useDarkMode,
    required this.preferredLanguage,
  });

  UserSettings copyWith({
    double? ttsSpeed,
    bool? useDarkMode,
    String? preferredLanguage,
  }) {
    return UserSettings(
      ttsSpeed: ttsSpeed ?? this.ttsSpeed,
      useDarkMode: useDarkMode ?? this.useDarkMode,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
    );
  }
}
