import 'dart:math' as math;

import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/axis_scale.dart';
import 'package:demo1/core/utils/chart_point.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// បន្ទាត់ដែលមានតំបន់ស្រមោល (target band)
class TrendLineChart extends StatelessWidget {
  const TrendLineChart({
    super.key,
    required this.points,
    required this.bandMin,
    required this.bandMax,
    required this.xInterval,
    required this.xLabel,
    this.unit = '',
    this.height = 200,
  });

  final List<ChartPoint> points;
  final double bandMin;
  final double bandMax;

  // label អ័ក្ស X បង្ហាញត្រង់ minX + k + xInterval
  final double xInterval;
  final String Function(double x) xLabel;
  final String unit;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return SizedBox(height: height);
    final ys = points.map((p) => p.y);
    final lo = math.min(ys.reduce(math.min), bandMin);
    final hi = math.max(ys.reduce(math.max), bandMax);
    final range = niceRange(lo, hi);

    final minX = points.first.x;
    final maxX = points.last.x > minX ? points.last.x : minX + 1;
    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: range.min,
          maxY: range.max,
          lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          rangeAnnotations: RangeAnnotations(
            horizontalRangeAnnotations: [
              HorizontalRangeAnnotation(
                y1: bandMin,
                y2: bandMax,
                color: AppColors.mintTint,
              ),
            ],
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: range.step,
            getDrawingHorizontalLine: (_) => FlLine(
              color: AppColors.black.withValues(alpha: 0.06),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: range.step,
                getTitlesWidget: (value, meta) {
                  final isTop = (value - range.max).abs() < 1e-9;
                  final text = formatReading(value);
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      isTop && unit.isNotEmpty ? '$text $unit' : text,
                      style: AppType.caption,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: xInterval,
                getTitlesWidget: (value, meta) {
                  // បង្ហាញតែត្រង់ពហុគុណនៃ xInterval (មិនថា chart ហៅតម្លៃអ្វីផ្សេង)
                  final k = (value - minX) / xInterval;
                  if ((k - k.round()).abs() > 1e-6 || value > maxX + 1e-9) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(xLabel(value), style: AppType.caption),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (final p in points) FlSpot(p.x, p.y)],
              color: AppColors.primary,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
