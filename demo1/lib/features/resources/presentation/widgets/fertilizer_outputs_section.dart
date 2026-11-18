import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/resources/data/models/fertilizer_dosing.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/presentation/viewmodels/dosing_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DosingOutputsSection extends StatelessWidget {
  const DosingOutputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DosingViewModel>();
    if (vm.recipe == null || vm.pumps.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'Outputs',
          actionLabel: 'Dosing controls',
          onAction: () {
            // TODO: ទំព័រការបញ្ជាដូស
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.cardSurface,
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Auto doses to the recipe. Switches show the current pump '
                'state, not the schedule.',
                style: AppType.caption,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final pump in vm.pumps) ...[
                _PumpRow(vm: vm, pump: pump),
                const SizedBox(height: AppSpacing.md),
              ],
              if (vm.error != null)
                _Warning('Sensors unreachable. Controls are disabled.')
              else if (vm.isTankLow)
                _Warning(
                  'Dosing blocked: mix tank below '
                  '${formatReading(vm.limits.minTankPercent)}%.',
                ),
              _PrimeRow(vm: vm),
            ],
          ),
        ),
      ],
    );
  }
}

class _Warning extends StatelessWidget {
  const _Warning(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: AppType.caption.copyWith(color: AppColors.warning),
      ),
    );
  }
}

class _PumpRow extends StatelessWidget {
  const _PumpRow({required this.vm, required this.pump});

  final DosingViewModel vm;
  final DosingPump pump;

  String get _status {
    if (vm.isBlocked) return 'Blocked';
    if (vm.isOn(pump.id)) return 'On · priming';
    if (vm.selectedPumpId == pump.id) return 'Off · test ready';
    return pump.manualOnly ? 'Off · idle' : 'Off · ready';
  }

  @override
  Widget build(BuildContext context) {
    final used = pump.usedTodayLitres;
    final subtitle = used == null
        ? pump.code
        : '${pump.code} · ${formatReading(used)} L today';
    final isManual = vm.modeOf(pump.id) == IrrigationMode.manual;

    return Column(
      children: [
        Row(
          children: [
            const IconTile(icon: Icons.upload_outlined),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pump.title, style: AppType.bodyStrong),
                  Text(subtitle, style: AppType.caption),
                ],
              ),
            ),
            // សូចនាករប៉ុណ្ណោះ: onChanged ជា null ដូច្នេះមិនអាចចុចបាន
            Switch(value: vm.isOn(pump.id), onChanged: null),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            SizedBox(
              width: 150,
              child: PillTabs(
                compact: true,
                labels: const ['Auto', 'Manual'],
                selectedIndex: isManual ? 1 : 0,
                onChanged: (i) => vm.setMode(
                  pump.id,
                  i == 0 ? IrrigationMode.auto : IrrigationMode.manual,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                _status,
                textAlign: TextAlign.right,
                style: AppType.caption.copyWith(
                  color: vm.isBlocked ? AppColors.warning : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PrimeRow extends StatelessWidget {
  const _PrimeRow({required this.vm});

  final DosingViewModel vm;

  @override
  Widget build(BuildContext context) {
    final running = vm.isRunning;
    final VoidCallback? action = running
        ? vm.stopPrime
        : (vm.canStartPrime ? vm.startPrime : null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: action,
          icon: Icon(running ? Icons.stop : Icons.colorize_outlined),
          label: Text(running ? 'Stop prime' : 'Prime selected pump'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mintTint,
            foregroundColor: AppColors.forestInk,
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Manual prime is limited to ${vm.primeLimit.inSeconds} seconds. '
          'Dosing stops if the mix tank falls below '
          '${formatReading(vm.limits.minTankPercent)}%.',
          style: AppType.caption,
        ),
      ],
    );
  }
}

// ===== "A little separation, by design" =====

class SeparationCard extends StatelessWidget {
  const SeparationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DosingViewModel>();
    if (vm.recipe == null) return const SizedBox.shrink();

    final last = vm.lastMix;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.verified_user_outlined,
                  size: 22,
                  color: AppColors.forestInk,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'A little separation, by design',
                    style: AppType.bodyStrong,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'A and B dose sequentially, with a '
              '${vm.mixingPauseSeconds}-second mixing pause. '
              'EC is checked again before the next dose.',
              style: AppType.body,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    // TODO: កំណត់ត្រាដូស
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 44),
                  ),
                  child: Text(
                    'View dosing log',
                    style: AppType.bodyStrong.copyWith(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
                if (last != null)
                  Text('Last mix ${last.format()}', style: AppType.caption),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
