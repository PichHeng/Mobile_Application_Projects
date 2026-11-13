import 'dart:math' as math;
import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/axis_scale.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class UsageBarChart extends StatelessWidget {
  const UsageBarChart({
    super.key,
    required this.points,
    this.unit = 'kWh',
    this.height = 180,
  });

  final List<UsagePoint> points;
  final String unit;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) return SizedBox(height: height);

    final maxValue = points.map((p) => p.value).reduce(math.max);
    final scale = niceScale(maxValue);
    final labelEvery = math.max(1, (points.length / 4).ceil());
    final lastIndex = points.length - 1;
    final barWidth = points.length > 14 ? 5.0 : 14.0;
    return SizedBox(
      height: height,
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: scale.max,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
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
                reservedSize: 48,
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
                  final i = value.toInt();
                  if (i < 0 || i > lastIndex || i % labelEvery != 0) {
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
          barGroups: [
            for (var i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].value,
                    width: barWidth,
                    color: i == lastIndex ? AppColors.sage : AppColors.primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
