import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:humble_time_app/core/providers/user_settings_provider.dart';
import 'package:humble_time_app/core/providers/tts_provider.dart';
import 'package:humble_time_app/core/utils/block_generator.dart';
import 'package:humble_time_app/core/navigation/bottom_nav_bar.dart';
//import 'package:humble_time_app/features/scheduler/widgets/schedule_block.dart';
//import 'package:humble_time_app/features/scheduler/widgets/block_timeline_view.dart';
import 'package:humble_time_app/features/scheduler/widgets/block_editor_sheet.dart';
import 'package:humble_time_app/models/task_type.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/features/scheduler/widgets/scheduler_body.dart';

class SchedulerScreen extends ConsumerStatefulWidget {
  const SchedulerScreen({super.key});

  @override
  ConsumerState<SchedulerScreen> createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends ConsumerState<SchedulerScreen> {
  List<TimeBlock> blocks = [];
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadBlocks();
    }
  }

  Future<void> _loadBlocks() async {
    final settings = ref.read(userSettingsProvider).settings;
    final locale = Localizations.localeOf(context);
    final generated = await generateTimeBlocks(settings, locale);
    if (mounted) {
      setState(() => blocks = generated);
    }
  }

  String _getAffirmation(TaskType type) {
    switch (type) {
      case TaskType.focusBlock:
        return 'Let’s dive in and stay present.';
      case TaskType.breakBlock:
        return 'Pause and recharge. You’ve earned it.';
      case TaskType.meditation:
        return 'Breathe deeply. This moment is yours.';
      case TaskType.other:
        return 'Time to move forward mindfully.';
    }
  }

  Future<void> _handleStartBlock() async {
    if (!mounted || blocks.isEmpty) return;

    final userSettings = ref.read(userSettingsProvider).settings;
    final tts = ref.read(ttsProvider);
    final locale = Localizations.localeOf(context);

    if (userSettings.enableVoiceNudge) {
      final affirmation = _getAffirmation(blocks.first.taskType);
      final prompt = await PromptLibrary.forEvent('startBlock', locale, param: affirmation);
      await tts.speak(prompt);
    }

    HapticFeedback.selectionClick();
    if (!mounted) return;
    context.push('/session', extra: blocks.first);
  }

  void _editBlock(TimeBlock block, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlockEditorSheet(
        block: block,
        onSave: (updated) {
          setState(() => blocks[index] = updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Scheduler screen',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Schedule Your Time'),
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
        bottomNavigationBar: const BottomNavBar(),
        body: SafeArea(
          child: SchedulerBody(
            blocks: blocks,
            onEdit: _editBlock,
            onStart: _handleStartBlock,
          ),
        ),
      ),
    );
  }
}
