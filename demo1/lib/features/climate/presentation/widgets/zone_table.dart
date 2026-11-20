import 'package:demo1/core/constants/app_colors.dart';
import 'package:demo1/core/constants/app_radius.dart';
import 'package:demo1/core/constants/app_spacing.dart';
import 'package:demo1/core/theme/app_type.dart';
import 'package:demo1/core/utils/reading_format.dart';
import 'package:demo1/features/climate/data/models/climate_trend.dart';
import 'package:flutter/material.dart';

class ZoneTable extends StatelessWidget {
  const ZoneTable({super.key, required this.today});
  final ClimateToday today;

  static const double _tempWidth = 64;
  static const double _humidityWidth = 44;
  static const double _statusWidth = 84;

  @override
  Widget build(BuildContext context) {
    final head = AppType.caption.copyWith(fontSize: 11, letterSpacing: 0.6);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text('ZONE', style: head)),
              SizedBox(
                width: _tempWidth,
                child: Text('TEMP', style: head, textAlign: TextAlign.right),
              ),
              const SizedBox(width: AppSpacing.sm),
              SizedBox(
                width: _statusWidth,
                child: Text('STATUS', style: head, textAlign: TextAlign.right),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(color: AppColors.mintTint, height: 1),
          const SizedBox(height: AppSpacing.md),
          for (var i = 0; i < today.zones.length; i++) ...[
            if (i >= 0) const SizedBox(height: AppSpacing.md),
            _ZoneRow(
              zone: today.zones[i],
              inRange: today.zoneInRange(today.zones[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _ZoneRow extends StatelessWidget {
  const _ZoneRow({required this.zone, required this.inRange});
  final ClimateZone zone;
  final bool inRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${zone.letter} · ${zone.name}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.body.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(
          width: ZoneTable._tempWidth,
          child: Text(
            '${formatReading(zone.temperature)} °C',
            textAlign: TextAlign.right,
            style: AppType.body,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: ZoneTable._humidityWidth,
          child: Text(
            '${formatReading(zone.humidity)}%',
            textAlign: TextAlign.right,
            style: AppType.body,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        SizedBox(
          width: ZoneTable._statusWidth,
          child: Text(
            inRange ? 'In range' : 'Out of range',
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppType.caption.copyWith(
              color: inRange ? AppColors.primary : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
