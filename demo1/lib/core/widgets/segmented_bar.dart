import 'package:flutter/material.dart';

class BarSegment {
  const BarSegment(this.value, this.color);
  final int value;
  final Color color;
}

class SegmentedBar extends StatelessWidget {
  const SegmentedBar({
    super.key,
    required this.segments,
    this.height = 4,
    this.gap = 4,
  });

  final List<BarSegment> segments;
  final double height;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final visible = segments.where((s) => s.value > 0).toList();
    if (visible.isEmpty) return SizedBox(height: height);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            for (var i = 0; i < visible.length; i++) ...[
              Expanded(
                flex: visible[i].value,
                child: ColoredBox(color: visible[i].color),
              ),
              if (i < visible.length - 1) SizedBox(width: gap),
            ],
          ],
        ),
      ),
    );
  }
}
