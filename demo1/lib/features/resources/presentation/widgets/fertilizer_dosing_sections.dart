import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/greenhouse/data/models/greenhouse_climate.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/presentation/viewmodels/dosing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DosingSections extends StatelessWidget {
  const DosingSections({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DosingViewModel>();
    final recipe = vm.recipe;
    final inputs = vm.inputs;

    if (recipe == null || inputs == null) {
      if (vm.error == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Could not read dosing data', style: AppType.bodyStrong),
            const SizedBox(height: AppSpacing.md),
            AppButton(label: 'Try again', onPressed: () => vm.load()),
          ],
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: "Today's recipe",
          actionLabel: 'Edit recipe',
          onAction: () {
            // ???
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _RecipeCard(vm: vm, recipe: recipe),
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(
          title: 'Inputs',
          trailingText: 'Mixing tank sensors',
        ),
        const SizedBox(height: AppSpacing.md),
        _InputsCard(vm: vm, inputs: inputs),
      ],
    );
  }
}

// Recipe

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.vm, required this.recipe});

  final DosingViewModel vm;
  final FertilizerRecipe recipe;

  String _mixLabel() {
    if (recipe.isEvenMix) return '1:1 mix';
    return '${formatReading(recipe.partA.doseMlPerLitre)}:'
        '${formatReading(recipe.partB.doseMlPerLitre)} mix';
  }

  String _nextMixTest() {
    final start = vm.nextMixStart;
    final time = start == null ? '' : DateFormat('HH:mm').format(start);
    final when = vm.nextMixIsToday ? time : 'tomorrow $time';
    return 'Next mix · $when'
        '${formatReading(recipe.nextMixWaterLitres)} L water +'
        '${formatReading(recipe.nextMixConcentrateMl)} mL concentrate';
  }

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
            children: [
              const Icon(
                Icons.science_outlined,
                size: 22,
                color: AppColors.white,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  recipe.name,
                  style: AppType.bodyStrong.copyWith(color: AppColors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  _mixLabel(),
                  style: AppType.chip.copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _PartColumn(part: recipe.partA)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _PartColumn(part: recipe.partB)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(_nextMixTest(), style: AppType.caption.copyWith(color: soft)),
        ],
      ),
    );
  }
}

class _PartColumn extends StatelessWidget {
  const _PartColumn({required this.part});
  final DosingPart part;

  @override
  Widget build(BuildContext context) {
    final soft = AppColors.white.withValues(alpha: 0.75);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Part ${part.letter} · ${part.name}',
          style: AppType.caption.copyWith(color: soft),
        ),
        const SizedBox(height: AppSpacing.xs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            '${formatReading(part.remainingLitres)} L',
            style: AppType.metricValue.copyWith(
              color: AppColors.white,
              fontSize: 36,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${formatReading(part.doseMlPerLitre)} mL / L water',
          style: AppType.caption.copyWith(color: soft),
        ),
        Text('remaining in tank', style: AppType.caption.copyWith(color: soft)),
      ],
    );
  }
}

class _InputsCard extends StatelessWidget {
  const _InputsCard({required this.vm, required this.inputs});

  final DosingViewModel vm;
  final DosingInputs inputs;

  String _target(RangedReading r, String unit) =>
      'Target ${formatReading(r.min)}–${formatReading(r.max)}'
      '${unit.isEmpty ? '' : ' $unit'}';

  @override
  Widget build(BuildContext context) {
    final low = vm.isTankLow;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InputRow(
            title: 'Electrical conductivity',
            subtitle: 'IN 04 · ${_target(inputs.ec, 'mS/cm')}',
            value: '${formatReading(inputs.ec.value)} mS/cm',
            warn: !inputs.ec.isInRange,
          ),
          const SizedBox(height: AppSpacing.md),
          _InputRow(
            title: 'Solution pH',
            subtitle: 'IN 05 · ${_target(inputs.ph, '')}',
            value: '${formatReading(inputs.ph.value)} pH',
            warn: !inputs.ph.isInRange,
          ),
          const SizedBox(height: AppSpacing.md),
          _InputRow(
            title: 'Electrical conductivity',
            subtitle: 'IN 06 · Low-level interlock',
            value:
                '${formatReading(inputs.tankPercent)}% · '
                '${low ? 'Low' : 'OK'}',
            warn: !inputs.ec.isInRange,
          ),
          if (low) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              'Interlock activ: dosing stays off below'
              '${formatReading(vm.limits.minTankPercent)}%.',
              style: AppType.caption.copyWith(color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.title,
    required this.subtitle,
    required this.value,
    this.warn = false,
  });

  final String title;
  final String subtitle;
  final String value;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const IconTile(icon: Icons.download_outlined),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppType.bodyStrong),
              Text(subtitle, style: AppType.caption),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppType.bodyStrong.copyWith(
            color: warn ? AppColors.warning : null,
          ),
        ),
      ],
    );
  }
}
