import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/core/widgets/app_button.dart';
import 'package:demo1/core/widgets/icon_tile.dart';
import 'package:demo1/core/widgets/pill_tabs.dart';
import 'package:demo1/core/widgets/section_header.dart';
import 'package:demo1/features/resources/data/models/water_io.dart';
import 'package:demo1/features/resources/data/models/water_report.dart';
import 'package:demo1/features/resources/presentation/viewmodels/water_controls_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.cardSurface,
  borderRadius: BorderRadius.circular(AppRadius.card),
);

// Inputs

class WaterInputsSection extends StatelessWidget {
  const WaterInputsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterControlsViewModel>();
    final inputs = vm.inputs;

    if (inputs == null) {
      if (vm.error == null) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Could not read sensors', style: AppType.bodyStrong),
            const SizedBox(height: AppSpacing.md),
            AppButton(label: 'Try Again', onPressed: () => vm.load()),
          ],
        ),
      );
    }

    // កូដ sensor ជាទិន្នន័យ mock។ ក្រោយមកវាមកពីការកំណត់ឧបករណ៍ពិត
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        const SectionHeader(title: 'Inputs', trailingText: 'Read-only sensors'),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: _cardDecoration(),
          child: Column(
            children: [
              _InputRow(
                title: 'Reservior level',
                code: 'IN 01 · Float sensor',
                value:
                    '${formatReading(inputs.reservoirPercent)}% · '
                    '${formatReading(inputs.reservoirLitres)} L',
              ),
              const SizedBox(height: AppSpacing.md),
              _InputRow(
                title: 'Line Pressure',
                code: 'IN 02 · Pressure transducer',
                value: '${formatReading(inputs.linePressureBar)} bar',
              ),
              const SizedBox(height: AppSpacing.md),
              _InputRow(
                title: 'Water flow',
                code: 'IN 03 · Flow meter',
                value: '${inputs.flowLitresPerMin.toStringAsFixed(1)} L/min',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InputRow extends StatelessWidget {
  const _InputRow({
    required this.title,
    required this.code,
    required this.value,
  });
  final String title;
  final String code;
  final String value;

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
              Text(code, style: AppType.caption),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(value, style: AppType.bodyStrong),
      ],
    );
  }
}

// Output

class WaterOutputsSection extends StatelessWidget {
  const WaterOutputsSection({super.key});

  String _blockText(WaterControlsViewModel vm) {
    final limits = vm.limits;
    return vm.blockers
        .map((b) {
          return switch (b) {
            SafetyBlock.reservoirLow =>
              'reservoir below ${formatReading(limits.minReservoirPercent)}%',
            SafetyBlock.pressureHigh =>
              'pressure above ${formatReading(limits.maxPressureBar)} bar',
          };
        })
        .join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WaterControlsViewModel>();
    if (vm.inputs == null) return const SizedBox.shrink();

    final isBlocked = vm.error != null || vm.blockers.isNotEmpty;
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        SectionHeader(
          title: 'Output',
          trailingText: '${vm.outputs.length} selected controls',
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Switches show output state. Auto follow the schedule;'
                'Manual enables a timed test.',
                style: AppType.caption,
              ),
              const SizedBox(height: AppSpacing.md),
              for (final output in vm.outputs) ...[
                _OutputRow(vm: vm, output: output, isBlocked: isBlocked),
                const SizedBox(height: AppSpacing.md),
              ],
              if (vm.error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Sensors unreachable.Controls are disabled',
                    style: AppType.caption.copyWith(color: AppColors.warning),
                  ),
                )
              else if (vm.blockers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Safety stop: ${_blockText(vm)}',
                    style: AppType.caption.copyWith(color: AppColors.warning),
                  ),
                ),
              _TestRow(vm: vm),
            ],
          ),
        ),
      ],
    );
  }
}

class _OutputRow extends StatelessWidget {
  const _OutputRow({
    required this.vm,
    required this.output,
    required this.isBlocked,
  });

  final WaterControlsViewModel vm;
  final OutputDef output;
  final bool isBlocked;

  String get _status {
    if (isBlocked) return 'Blocked';
    if (vm.isOn(output.id)) return 'On · test running ';
    return vm.modeOf(output.id) == IrrigationMode.manual
        ? 'Off · test ready'
        : 'Off · ready';
  }

  @override
  Widget build(BuildContext context) {
    final mode = vm.modeOf(output.id);
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
                  Text(output.title, style: AppType.bodyStrong),
                  Text(output.code, style: AppType.caption),
                ],
              ),
            ),
            // សូចនាករប៉ុណ្ណោះ: onChanged ជា null ដូច្នេះមិនអាចចុចបាន
            Switch(value: vm.isOn(output.id), onChanged: null),
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
                selectedIndex: mode == IrrigationMode.auto ? 0 : 1,
                onChanged: (i) => vm.setMode(
                  output.id,
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
                  color: isBlocked ? AppColors.warning : null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TestRow extends StatelessWidget {
  const _TestRow({required this.vm});
  final WaterControlsViewModel vm;

  @override
  Widget build(BuildContext context) {
    final running = vm.isRunning;
    final VoidCallback? action = running
        ? vm.stopTest
        : (vm.canStartTest ? vm.startTest : null);
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: action,
          icon: Icon(running ? Icons.stop : Icons.play_arrow_outlined),
          label: Text(running ? 'Stop test' : 'Manual test'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.mintTint,
            foregroundColor: AppColors.forestInk,
            minimumSize: const Size(170, 52),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            '${vm.testLimit.inMinutes} min maximum.\nReturns to Auto.',
            style: AppType.caption,
          ),
        ),
      ],
    );
  }
}
