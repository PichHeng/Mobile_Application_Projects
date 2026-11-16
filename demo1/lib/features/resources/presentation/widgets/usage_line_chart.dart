import 'dart:math' as math;

import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/axis_scale.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// បន្ទាត់ជណ្តើរ។ ផ្តល់ចំណុចដែលបូកបន្តរួចហើយ (cumulativePoints)
class UsageLineChart extends StatelessWidget {
  const UsageLineChart({
    super.key,
    required this.points,
    this.unit = 'L',
    this.height = 160,
  });

  final List<UsagePoint> points;
  final String unit;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return SizedBox(height: height);

    final maxValue = points.map((p) => p.value).reduce(math.max);
    final scale = niceScale(maxValue);
    final labelEvery = axisLabelStep(points.length);
    final lastIndex = points.length - 1;

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: math.max(1, lastIndex).toDouble(),
          minY: 0,
          maxY: scale.max,
          lineTouchData: LineTouchData(enabled: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: scale.step,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: AppColors.mintTint, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 52,
                interval: scale.step,
                getTitlesWidget: (value, meta) {
                  final isTop = (value - scale.max).abs() < 1e-9;
                  final text = isTop
                      ? '${formatReading(value)} $unit'
                      : formatReading(value);
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(text, style: AppType.caption),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final i = value.round();
                  final isWhole = (value - i).abs() < 1e-9;
                  if (!isWhole ||
                      i < 0 ||
                      i > lastIndex ||
                      i % labelEvery != 0) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(points[i].label, style: AppType.caption),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var i = 0; i < points.length; i++)
                  FlSpot(i.toDouble(), points[i].value),
              ],
              isStepLineChart: true,
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
