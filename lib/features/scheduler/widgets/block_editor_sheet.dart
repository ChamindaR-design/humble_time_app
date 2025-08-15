import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humble_time_app/models/task_type.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/services/voice_service.dart';
import 'package:humble_time_app/helpers/prompt_library.dart';

class BlockEditorSheet extends StatefulWidget {
  final TimeBlock block;
  final void Function(TimeBlock updated) onSave;

  const BlockEditorSheet({
    super.key,
    required this.block,
    required this.onSave,
  });

  @override
  State<BlockEditorSheet> createState() => _BlockEditorSheetState();
}

class _BlockEditorSheetState extends State<BlockEditorSheet> {
  late TextEditingController _controller;
  late Duration duration;
  late TaskType taskType;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.block.label);
    duration = widget.block.duration;
    taskType = widget.block.taskType;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _previewVoice() async {
    final locale = Localizations.localeOf(context);
    final preview = await PromptLibrary.forEvent(
      'blockPreview',
      locale,
      param: _controller.text,
    );
    VoiceService.speak(preview);
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Block editor sheet',
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Block Title'),
              controller: _controller,
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Duration slider, currently ${duration.inMinutes} minutes',
              child: Row(
                children: [
                  const Text('Duration:'),
                  Expanded(
                    child: Slider(
                      value: duration.inMinutes.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      label: '${duration.inMinutes} min',
                      onChanged: (val) => setState(() {
                        duration = Duration(minutes: val.round());
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Semantics(
              label: 'Task type dropdown',
              child: DropdownButton<TaskType>(
                value: taskType,
                items: TaskType.values.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type.name),
                  );
                }).toList(),
                onChanged: (val) => setState(() => taskType = val!),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Preview Voice'),
                  onPressed: _previewVoice,
                ),
                Semantics(
                  label: 'Save block edits',
                  child: ElevatedButton(
                    onPressed: () {
                      final updated = TimeBlock(
                        label: _controller.text,
                        duration: duration,
                        isBreak: taskType == TaskType.breakBlock,
                      );
                      widget.onSave(updated);
                      Navigator.pop(context);
                    },
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
