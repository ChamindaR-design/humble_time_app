import 'package:flutter/material.dart';
import 'package:humble_time_app/models/time_block.dart';
import 'package:humble_time_app/widgets/narrated_block_tile.dart';

class BlockTimelineView extends StatelessWidget {
  final List<TimeBlock> blocks;
  final void Function(TimeBlock block)? onBlockTap;

  const BlockTimelineView({
    super.key,
    required this.blocks,
    this.onBlockTap,
  });

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12), // ✅ Adds space below scroll strip
      child: SizedBox(
        height: 132,
        child: Scrollbar(
          controller: scrollController,
          thumbVisibility: true,
          child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              final block = blocks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: NarratedBlockTile(
                  block: block,
                  index: index,
                  onTap: () => onBlockTap?.call(block),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
