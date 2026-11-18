import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_controls_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WaterScheduleSection extends StatelessWidget {
  const WaterScheduleSection({super.key});

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterControlsViewModel>();
    final upcoming = vm.upcomingCycles;
    if (vm.inputs == null || upcoming.isEmpty) return const SizedBox.shrink();

    final first = upcoming.first;
    final second = upcoming.length > 1 ? upcoming[1] : null;
    final timeFormat = DateFormat('HH:mm');
    final label = _isSameDay(first.start, vm.now) ? 'NEXT CYCLE' : 'TOMORROW';

    // ព្រំដែនសុវត្ថិភាពមកពី SafetyLimits មិនមែនអត្ថបទថេរ
    // ដូច្នេះបើតម្លៃប្តូរ អត្ថបទប្តូរតាមដោយស្វ័យប្រវត្តិ
    final safety =
        'Safety stop: reservoir below '
        '${formatReading(vm.limits.minReservoirPercent)}% or pressure above '
        '${formatReading(vm.limits.maxPressureBar)} bar.';
    final next = second == null
        ? ''
        : ' Next: ${second.cycle.zoneName} at '
              '${timeFormat.format(second.start)}.';

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'Coming up',
          actionLabel: 'Edit schedule',
          onAction: () {
            // TODO: ទំព័រកែកាលវិភាគ
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _CycleCard(
          time: timeFormat.format(first.start),
          label: label,
          title: '${first.cycle.zoneName} · ${first.cycle.cropName}',
          detail:
              '${first.cycle.durationMinutes} min · '
              'est. ${formatReading(first.cycle.estimatedLitres)} L · '
              'every day',
          note: '$safety$next',
        ),
      ],
    );
  }
}

class _CycleCard extends StatelessWidget {
  const _CycleCard({
    required this.time,
    required this.label,
    required this.title,
    required this.detail,
    required this.note,
  });

  final String time;
  final String label;
  final String title;
  final String detail;
  final String note;

  @override
  Widget build(BuildContext context) {
    final soft = AppColors.white.withValues(alpha: 0.75);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.forestInk,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      time,
                      style: AppType.metricValue.copyWith(
                        color: AppColors.white,
                        fontSize: 40,
                      ),
                    ),
                    Text(label, style: AppType.caption.copyWith(color: soft)),
                  ],
                ),
              ),
              Icon(Icons.edit_calendar_outlined, size: 28, color: soft),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: AppType.bodyStrong.copyWith(color: AppColors.white),
          ),
          Text(detail, style: AppType.caption.copyWith(color: soft)),
          const SizedBox(height: AppSpacing.md),
          Text(note, style: AppType.body.copyWith(color: soft)),
        ],
      ),
    );
  }
}
