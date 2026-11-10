import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/alert_card.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/hero_card.dart';
import 'package:demo1/core/widgets/insight_card.dart';
import 'package:demo1/core/widgets/metric_card.dart';
import 'package:demo1/core/widgets/readings_footer.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/auth/presentation/viewmodels/session_view_model.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/greenhouse/data/models/overview_summary.dart';
import 'package:demo1/features/overview/presentation/viewmodels/overview_view_model.dart';
import 'package:demo1/features/overview/presentation/widgets/health_card.dart';
import 'package:demo1/features/overview/presentation/widgets/resources_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  static const ImageProvider _heroImage = AssetImage(
    'assets/images/hero_greenhouse.png',
  );

  String _greeting(DayPart part) => switch (part) {
    DayPart.morning => 'Good morning',
    DayPart.afternoon => 'Good afternoon',
    DayPart.evening => 'Good evening',
  };

  String _rootsSubtitle(RootsInsight roots) {
    final temp = '${formatReading(roots.soilTemperature)} °C soil';
    final zone = roots.lowMoistureZone;
    return zone == null
        ? '$temp · Moisture is on target'
        : '$temp · $zone moisture is low';
  }

  String _alertMessage(MoistureAlert a) {
    final target =
        '${formatReading(a.targetMin)}–${formatReading(a.targetMax)}%';
    final time = DateFormat('HH:mm').format(a.nextIrrigation);
    return '${a.cropName} bed moisture is ${formatReading(a.moisture)}%, '
        'below its $target target. '
        'Check the drippers before the next cycle at $time.';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OverviewViewModel>();
    final name = context.watch<SessionViewModel>().user?.displayName ?? '';
    final climate = vm.climate;
    final summary = vm.summary;

    return Scaffold(
      body: SafeArea(
        child: (!vm.hasData || climate == null || summary == null)
            ? _Placeholder(vm: vm)
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                children: [
                  const _TopBar(),
                  const SizedBox(height: AppSpacing.md),
                  const _GreenhouseLabel(),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${_greeting(vm.dayPart)}, $name',
                    style: AppType.headline,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${DateFormat('EEEE, d MMMM').format(vm.today)}'
                    ' · A good day to grow.',
                    style: AppType.label,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  HeroCard(
                    title: 'A little care.\nA lot of growth.',
                    countText: summary.zoneCount.toString().padLeft(2, '0'),
                    countLabel: 'growing zones',
                    image: _heroImage,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: 'In the greenhouse',
                    actionLabel: 'Climate',
                    onAction: () => context.go('/climate'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _ClimateGrid(climate: climate),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: "Today's resources",
                    actionLabel: 'Usage & controls',
                    onAction: () => context.go('/overview/resources/energy'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ResourcesCard(resources: summary.resources),
                  const SizedBox(height: AppSpacing.xl),
                  SectionHeader(
                    title: 'Growing well',
                    actionLabel: 'Plants',
                    onAction: () => context.go('/plants'),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  HealthCard(health: summary.health),
                  const SizedBox(height: AppSpacing.md),
                  InsightCard(
                    icon: Icons.spa_outlined,
                    title: 'At the roots',
                    subtitle: _rootsSubtitle(summary.roots),
                    onTap: () => context.go('/soil'),
                  ),
                  if (summary.alerts.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xl),
                    SectionHeader(
                      title: 'A little attention',
                      trailingText: summary.alerts.length == 1
                          ? '1 alert'
                          : '${summary.alerts.length} alerts',
                    ),
                    const SizedBox(height: AppSpacing.md),
                    for (final alert in summary.alerts) ...[
                      AlertCard(
                        title: '${alert.zoneName} is getting thirsty',
                        message: _alertMessage(alert),
                        actionLabel: 'Review water & irrigation',
                        onAction: () => context.go('/overview/resources/water'),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  ReadingsFooter(time: vm.today),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.vm});

  final OverviewViewModel vm;

  @override
  Widget build(BuildContext context) {
    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Could not load data', style: AppType.bodyStrong),
              const SizedBox(height: AppSpacing.md),
              AppButton(label: 'Try again', onPressed: () => vm.load()),
            ],
          ),
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.eco_outlined, color: AppColors.forestInk, size: 28),
        const SizedBox(width: AppSpacing.sm),
        const Text('PlantX', style: AppType.brand),
        const Spacer(),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.cardSurface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.notifications_none,
            color: AppColors.forestInk,
          ),
        ),
      ],
    );
  }
}

class _GreenhouseLabel extends StatelessWidget {
  const _GreenhouseLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.home_work_outlined,
          size: 20,
          color: AppColors.forestInk,
        ),
        const SizedBox(width: AppSpacing.sm),
        const Expanded(
          child: Text('Greenhouse 01 · North house', style: AppType.body),
        ),
        Text('DEMO DATA', style: AppType.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _ClimateGrid extends StatelessWidget {
  const _ClimateGrid({required this.climate});

  final GreenhouseClimate climate;

  MetricCard _card(String label, IconData icon, RangedReading r, String unit) {
    return MetricCard(
      label: label,
      icon: icon,
      value: formatReading(r.value),
      unit: unit,
      targetText:
          'Target ${formatReading(r.min)}–${formatReading(r.max)} $unit',
      isInRange: r.isInRange,
    );
  }

  Widget _row(Widget a, Widget b) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: a),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: b),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(
          _card('Temperature', Icons.thermostat, climate.temperature, '°C'),
          _card('Humidity', Icons.water_drop_outlined, climate.humidity, '%'),
        ),
        const SizedBox(height: AppSpacing.md),
        _row(
          _card(
            'Light · PPFD',
            Icons.wb_sunny_outlined,
            climate.light,
            'µmol/m²/s',
          ),
          _card('Carbon dioxide', Icons.air, climate.co2, 'ppm'),
        ),
      ],
    );
  }
}
