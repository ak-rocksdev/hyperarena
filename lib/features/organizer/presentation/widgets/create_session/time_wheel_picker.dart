import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Minute options — the flow only schedules on quarter hours, so the picker
/// exposes exactly those instead of snapping silently after the fact.
const List<int> _minutes = [0, 15, 30, 45];

/// Common session start times for one-tap selection.
const List<(int, int)> _quickTimes = [
  (7, 0),
  (8, 0),
  (9, 0),
  (17, 0),
  (18, 0),
  (19, 0),
];

/// Branded bottom-sheet time picker: quick chips for common starts + two
/// scroll wheels (hour · quarter-hour). Returns "HH:mm", or null if dismissed.
Future<String?> showTimeWheelPicker(
  BuildContext context, {
  String? initial,
}) {
  var hour = 8;
  var minuteIndex = 0;
  if (initial != null) {
    final parts = initial.split(':');
    hour = (int.tryParse(parts.first) ?? 8).clamp(0, 23);
    final m = int.tryParse(parts.last) ?? 0;
    minuteIndex = _minutes.indexOf((m ~/ 15) * 15);
    if (minuteIndex < 0) minuteIndex = 0;
  }
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) =>
        _TimeWheelSheet(initialHour: hour, initialMinuteIndex: minuteIndex),
  );
}

class _TimeWheelSheet extends StatefulWidget {
  const _TimeWheelSheet({
    required this.initialHour,
    required this.initialMinuteIndex,
  });

  final int initialHour;
  final int initialMinuteIndex;

  @override
  State<_TimeWheelSheet> createState() => _TimeWheelSheetState();
}

class _TimeWheelSheetState extends State<_TimeWheelSheet> {
  static const double _itemExtent = 44;

  late int _hour = widget.initialHour;
  late int _minuteIndex = widget.initialMinuteIndex;
  late final FixedExtentScrollController _hourCtrl =
      FixedExtentScrollController(initialItem: _hour);
  late final FixedExtentScrollController _minuteCtrl =
      FixedExtentScrollController(initialItem: _minuteIndex);

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  String get _result =>
      '${_hour.toString().padLeft(2, '0')}:${_minutes[_minuteIndex].toString().padLeft(2, '0')}';

  void _applyQuick(int h, int m) {
    final mi = _minutes.indexOf(m);
    _hourCtrl.animateToItem(h,
        duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    _minuteCtrl.animateToItem(mi < 0 ? 0 : mi,
        duration: const Duration(milliseconds: 280), curve: Curves.easeOut);
    setState(() {
      _hour = h;
      _minuteIndex = mi < 0 ? 0 : mi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppDimensions.lg, AppDimensions.sm,
            AppDimensions.lg, AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.base),
            Row(
              children: [
                Text('Pilih jam',
                    style: AppTypography.titleMedium
                        .copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.sm),
            Text(
              'CEPAT',
              style: AppTypography.overline.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Wrap(
              spacing: AppDimensions.xs,
              runSpacing: AppDimensions.xs,
              children: [
                for (final (h, m) in _quickTimes)
                  _QuickChip(
                    label:
                        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}',
                    selected: _hour == h && _minutes[_minuteIndex] == m,
                    onTap: () => _applyQuick(h, m),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              height: 176,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Center selection band.
                  Container(
                    height: _itemExtent,
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _wheel(
                          controller: _hourCtrl,
                          count: 24,
                          selectedIndex: _hour,
                          labelFor: (i) => i.toString().padLeft(2, '0'),
                          onChanged: (i) => setState(() => _hour = i),
                        ),
                      ),
                      Text(':',
                          style: AppTypography.displaySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontWeight: FontWeight.w700,
                          )),
                      Expanded(
                        child: _wheel(
                          controller: _minuteCtrl,
                          count: _minutes.length,
                          selectedIndex: _minuteIndex,
                          labelFor: (i) =>
                              _minutes[i].toString().padLeft(2, '0'),
                          onChanged: (i) => setState(() => _minuteIndex = i),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.lg),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeightLg,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(_result),
                child: Text('Pilih $_result'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _wheel({
    required FixedExtentScrollController controller,
    required int count,
    required int selectedIndex,
    required String Function(int) labelFor,
    required ValueChanged<int> onChanged,
  }) {
    return ListWheelScrollView.useDelegate(
      controller: controller,
      itemExtent: _itemExtent,
      physics: const FixedExtentScrollPhysics(),
      perspective: 0.0022,
      diameterRatio: 1.5,
      onSelectedItemChanged: onChanged,
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: count,
        builder: (context, i) {
          final selected = i == selectedIndex;
          return Center(
            child: Text(
              labelFor(i),
              style: AppTypography.headingMedium.copyWith(
                color: selected ? AppColors.primary900 : AppColors.textTertiary,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base, vertical: AppDimensions.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary50 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.neutral300,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: selected ? AppColors.primary900 : AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}
