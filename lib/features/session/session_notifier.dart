import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:humble_time_app/models/session.dart';
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/session/session_manager.dart';

final sessionNotifierProvider = StateNotifierProvider<SessionNotifier, Session?>((ref) {
  return SessionNotifier(ref);
});

class SessionNotifier extends StateNotifier<Session?> {
  final Ref ref;

  SessionNotifier(this.ref) : super(null);

  void startSession(LogBlockType type, {bool usedVoice = false, String? note, List<String>? tags}) {
    state = Session(
      startTime: DateTime.now(),
      blockType: type,
      usedVoicePrompts: usedVoice,
      note: note,
      tags: tags,
    );
  }

  void endSession() {
    if (state == null) return;

    final completed = Session(
      startTime: state!.startTime,
      endTime: DateTime.now(),
      blockType: state!.blockType,
      usedVoicePrompts: state!.usedVoicePrompts,
      note: state!.note,
      tags: state!.tags,
    );

    ref.read(sessionManagerProvider).completeSession(
      start: completed.startTime,
      end: completed.endTime!,
      type: completed.blockType,
      usedVoice: completed.usedVoicePrompts,
      note: completed.note,
      tags: completed.tags,
    );

    state = null;
  }

  void cancelSession() {
    state = null;
  }
}
