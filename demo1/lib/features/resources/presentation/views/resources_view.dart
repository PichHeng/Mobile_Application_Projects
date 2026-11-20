import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/core/widgets/screen_top_bar.dart';
import 'package:demo1/features/resources/presentation/resource_type.dart';
import 'package:demo1/features/resources/presentation/widgets/energy_section.dart';
import 'package:demo1/features/resources/presentation/widgets/fertilizer_section.dart';
import 'package:demo1/features/resources/presentation/widgets/water_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResourcesView extends StatelessWidget {
  const ResourcesView({super.key, required this.type});

  final ResourceType type;

  String get _title => switch (type) {
    ResourceType.energy => 'Energy usage',
    ResourceType.water => 'Water & irrigation',
    ResourceType.fertilizer => 'Nutrients & dosing',
  };

  String get _subtitle => switch (type) {
    ResourceType.energy => 'A lighter footprint, from seed to harvest.',
    ResourceType.water => "Every drop, right where it's needed.",
    ResourceType.fertilizer => 'Balanced nourishment. Measured with care.',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            const ScreenTopBar(),
            const SizedBox(height: AppSpacing.md),
            Text(_title, style: AppType.headline),
            const SizedBox(height: AppSpacing.xs),
            Text(_subtitle, style: AppType.label),
            const SizedBox(height: AppSpacing.lg),
            PillTabs(
              labels: const ['Energy', 'Water', 'Fertilizer'],
              selectedIndex: type.index,
              onChanged: (i) => context.go(
                '/overview/resources/${ResourceType.values[i].name}',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            switch (type) {
              ResourceType.energy => const EnergySection(),
              ResourceType.water => const WaterSection(),
              ResourceType.fertilizer => const FertilizerSection(),
            },
          ],
        ),
      ),
    );
  }
}
