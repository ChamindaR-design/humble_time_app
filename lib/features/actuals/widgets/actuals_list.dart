import 'package:flutter/material.dart';
import 'package:humble_time_app/features/actuals/services/actuals_store.dart';

class ActualsList extends StatelessWidget {
  final ActualsStore store;

  const ActualsList({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final entries = store.entries;
        if (entries.isEmpty) {
          return const _EmptyState();
        }
        return ListView.separated(
          itemCount: entries.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final e = entries[index];
            return ListTile(
              leading: const Icon(Icons.fact_check),
              title: Text(e.text),
              subtitle: Text(_formatTime(e.createdAt)),
              dense: true,
            );
          },
        );
      },
    );
  }

  String _formatTime(DateTime dt) {
    // Keep it dependency-light; simple, readable timestamp.
    String two(int n) => n.toString().padLeft(2, '0');
    final d = dt.toLocal();
    //final two = (int n) => n.toString().padLeft(2, '0');
    return "${d.year}-${two(d.month)}-${two(d.day)} ${two(d.hour)}:${two(d.minute)}";
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No actuals yet.\nYour first entry will appear here.",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
