import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/resources/data/models/fertilizer_report.dart';
import 'package:demo1/features/resources/data/models/usage_series.dart';
import 'package:demo1/features/resources/data/repositories/resource_usage_repository.dart';
import 'package:demo1/features/resources/presentation/viewmodels/fertilizer_view_model.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_card.dart';
import 'package:demo1/features/resources/presentation/widgets/usage_line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FertilizerSection extends StatelessWidget {
  const FertilizerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          FertilizerViewModel(ctx.read<ResourceUsageRepository>())..load(),
      child: const Column(
        children: [
          _FertilizerUsageCard(),
          // TODO មេរៀនទី ១៩: Today's recipe, Inputs
        ],
      ),
    );
  }
}

class _FertilizerUsageCard extends StatelessWidget {
  const _FertilizerUsageCard();

  String _unit(UsagePeriod p) => switch (p) {
    UsagePeriod.today => 'L today',
    UsagePeriod.week => 'L in 7 days',
    UsagePeriod.month => 'L in 30 days',
  };

  String _planLabel(PlanStatus status, UsagePeriod period) {
    final plan = period == UsagePeriod.today ? 'daily plan' : 'plan';
    return switch (status) {
      PlanStatus.onPlan => 'On $plan',
      PlanStatus.overPlan => 'Above $plan',
      PlanStatus.underPlan => 'Below $plan',
    };
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FertilizerViewModel>();
    final report = vm.report;

    return UsageCard(
      title: 'Concentrate used',
      period: vm.period,
      onPeriodChange: vm.selectPeriod,
      series: vm.series,
      hasError: vm.error != null,
      onRetry: vm.load,
      unit: _unit(vm.period),
      chartBuilder: (s) => UsageLineChart(points: s.cumulativePoints),
      trailingBuilder: (_) {
        if (report == null) return null;
        final status = report.planStatus;
        return Text(
          _planLabel(status, vm.period),
          style: AppType.caption.copyWith(
            color: status == PlanStatus.onPlan
                ? AppColors.primary
                : AppColors.warning,
            fontWeight: FontWeight.w600,
          ),
        );
      },
      captionBuilder: (_) {
        if (report == null) return null;
        return 'A + B combined · '
            '${formatReading(report.mixPreparedLitres)} L of nutrient mix prepared';
      },
    );
  }
}
