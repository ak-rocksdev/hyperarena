import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/section_result.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';

class CoachDashboardSportBreakdown extends StatelessWidget {
  const CoachDashboardSportBreakdown({super.key, required this.result});
  final SectionResult<Map<Sport, int>> result;

  @override
  Widget build(BuildContext context) {
    return switch (result) {
      SectionFailure() => const SizedBox.shrink(),
      SectionSuccess(:final value) when value.isEmpty => const SizedBox.shrink(),
      SectionSuccess(:final value) => _Chart(data: value),
    };
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.data});
  final Map<Sport, int> data;

  @override
  Widget build(BuildContext context) {
    final total = data.values.fold<int>(0, (a, b) => a + b);
    if (total == 0) return const SizedBox.shrink();
    final sections = data.entries
        .map((e) => PieChartSectionData(
              value: e.value.toDouble(),
              title: '${e.value}',
              radius: 50,
            ))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Distribusi Murid', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.md),
        SizedBox(
          height: 180,
          child: PieChart(PieChartData(sections: sections, sectionsSpace: 2)),
        ),
        const SizedBox(height: AppDimensions.sm),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.xs,
          children: data.entries
              .map((e) => Chip(
                    label: Text(
                        '${SportChipSelector.sportLabel(e.key)}: ${e.value}'),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
