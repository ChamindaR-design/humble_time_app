// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get focusBlockTitle => '集中ブロック';

  @override
  String get breakBlockTitle => '休憩ブロック';

  @override
  String get timeMosaicPlanner => 'タイムモザイクプランナー';

  @override
  String get appTitle => 'Humble Time Tracker';

  @override
  String get logHistory => 'ログ履歴';

  @override
  String get actuals => '実績';

  @override
  String get pacing => 'ペーシング';

  @override
  String get scheduler => 'スケジューラー';

  @override
  String get settings => '設定';

  @override
  String get journalReview => 'ジャーナルレビュー';

  @override
  String get reflectionHistory => '振り返り履歴';

  @override
  String get languageSwitched => '言語が日本語に変更されました';

  @override
  String get voiceFocusStart => '集中ブロックを開始しました。今に意識を向けて、ペースを保ちましょう。';

  @override
  String get voiceFocusComplete => 'お疲れさまでした。集中した時間をしっかり使えましたね。気分を記録しますか？';

  @override
  String get voiceIdleDetected => '少し間が空いたようです。ブロックを再開しますか？それとも進捗を保存しますか？';

  @override
  String get voiceBreakStart => '休憩の時間です';

  @override
  String get voiceMoodPrompt => '今の気分はどうですか？';

  @override
  String get voiceMoodSaved => '気分を保存しました。続けましょう。';

  @override
  String voiceMoodSelected(String mood) {
    return '「$mood」が選択されました。続けましょう。';
  }

  @override
  String get voiceWelcomeBack => 'おかえりなさい。次の集中ブロックを始めましょうか？';

  @override
  String get voiceLeavingSession => 'もう終了しますか？このセッションを保存してから退出しますか？';

  @override
  String get voiceGenericFallback => '続けましょう。';

  @override
  String get mood => '気分';

  @override
  String get moodHappy => 'うれしい';

  @override
  String get moodNeutral => '普通';

  @override
  String get moodSad => '悲しい';

  @override
  String get moodCrying => '泣いている';

  @override
  String get moodJoyful => '喜び';

  @override
  String get moodAngry => '怒っている';

  @override
  String get moodSurprised => '驚き';

  @override
  String get moodConfused => '混乱している';

  @override
  String get moodSleepy => '眠い';
}
