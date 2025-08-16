// Screen for session-based focus pacing with voice affirmations.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:humble_time_app/features/session/session_notifier.dart';
import 'package:humble_time_app/models/session.dart'; // ✅ for Session
import 'package:humble_time_app/models/log_entry.dart';
import 'package:humble_time_app/features/session/session_reflection_screen.dart'; // ✅ for ReflectionScreen

class PacingScreen extends ConsumerStatefulWidget {
  const PacingScreen({super.key});

  @override
  ConsumerState<PacingScreen> createState() => _PacingScreenState();
}

class _PacingScreenState extends ConsumerState<PacingScreen> {
  DateTime? sessionStart;
  Duration elapsed = Duration.zero;
  late final Stopwatch ticker;
  late final FlutterTts flutterTts;
  late final List<String> affirmations;
  int nextAffirmationTime = 300;

  @override
  void initState() {
    super.initState();
    ticker = Stopwatch();
    _initializeTts();
    _loadAffirmations();
  }

  void _initializeTts() {
    flutterTts = FlutterTts();
    flutterTts.setSpeechRate(0.5);
  }

  void _loadAffirmations() {
    affirmations = <String>[
      "You're doing great.",
      "Stay focused, and take a deep breath.",
      "This moment matters.",
      "Let go of distractions and return to your flow.",
      "You're calm, capable, and grounded."
    ];
  }

  @override
  void dispose() {
    ticker.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionNotifierProvider); // ✅ Still correct
    return Scaffold(
      appBar: AppBar(title: const Text('Session')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _buildSessionUI(session),
      ),
    );
  }

  Widget _buildSessionUI(Session? session) { // ✅ Updated type
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          session != null
              ? '${session.blockType.name.toUpperCase()} BLOCK'
              : 'Not running',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          semanticsLabel: 'Session block type',
        ),
        const SizedBox(height: 24),
        Text(
          _formatTime(elapsed),
          style: const TextStyle(fontSize: 48),
          semanticsLabel: 'Elapsed session time',
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: session == null ? _startSession : _endSession,
          child: Text(session == null ? 'Start Session' : 'End Session'),
        ),
      ],
    );
  }

  String _formatTime(Duration d) =>
      '${d.inMinutes.toString().padLeft(2, '0')}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';

  void _startSession() {
    final now = DateTime.now();
    ref.read(sessionNotifierProvider.notifier).startSession(LogBlockType.focusBlock);
    ticker..reset()..start();
    sessionStart = now;
    nextAffirmationTime = 300;
    _tick();
  }

  void _endSession() async {
    final session = ref.read(sessionNotifierProvider);
    if (session == null) return;

    ref.read(sessionNotifierProvider.notifier).endSession();
    ticker..stop()..reset();
    setState(() => elapsed = Duration.zero);

    final journalNote = await _promptJournaling();
    if (!mounted) return;

    // ✨ Using the Bonus Tip: session.toLogEntry(...)
    final entry = session.toLogEntry(
      overrideNote: journalNote,
      overrideTags: [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SessionReflectionScreen(entry: entry)),
    );
  }

  Future<String?> _promptJournaling() async {
    String tempNote = '';
    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reflect on your session'),
          content: TextField(
            autofocus: true,
            maxLines: 5,
            decoration: const InputDecoration(hintText: 'What came up?'),
            onChanged: (val) => tempNote = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('Skip'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, tempNote),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _tick() async {
    while (ticker.isRunning) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => elapsed = ticker.elapsed);

      if (elapsed.inSeconds >= nextAffirmationTime) {
        _speakAffirmation();
        nextAffirmationTime += 300;
      }
    }
  }

  void _speakAffirmation() async {
    final index = (elapsed.inMinutes ~/ 5) % affirmations.length;
    await flutterTts.speak(affirmations[index]);
  }
}

// ✨ Bonus Tip: Cleaner Session → LogEntry conversion
extension SessionConversion on Session {
  LogEntry toLogEntry({String? overrideNote, List<String>? overrideTags}) {
    if (endTime == null) throw Exception("Session is not yet complete.");
    return LogEntry(
      startTime: startTime,
      endTime: endTime!,
      blockType: blockType,
      usedVoicePrompts: usedVoicePrompts,
      note: overrideNote ?? note ?? '',
      tags: overrideTags ?? tags ?? [],
    );
  }
}
