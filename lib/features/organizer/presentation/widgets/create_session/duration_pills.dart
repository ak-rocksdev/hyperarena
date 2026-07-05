import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

const _presets = <int, String>{
  60: '1 jam',
  90: '1½ jam',
  120: '2 jam',
  180: '3 jam',
};

/// Duration selector: preset pills + a Custom pill that reveals a minutes
/// field (15–480, step 15). Emits the chosen duration in minutes.
class DurationPills extends StatefulWidget {
  const DurationPills({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  State<DurationPills> createState() => _DurationPillsState();
}

class _DurationPillsState extends State<DurationPills> {
  late bool _custom = !_presets.containsKey(widget.value);
  late final TextEditingController _controller =
      TextEditingController(text: widget.value.toString());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.xs,
          runSpacing: AppDimensions.xs,
          children: [
            for (final e in _presets.entries)
              _Pill(
                label: e.value,
                selected: !_custom && widget.value == e.key,
                onTap: () {
                  setState(() => _custom = false);
                  widget.onChanged(e.key);
                },
              ),
            _Pill(
              label: 'Custom',
              selected: _custom,
              onTap: () => setState(() => _custom = true),
            ),
          ],
        ),
        if (_custom) ...[
          const SizedBox(height: AppDimensions.sm),
          Row(
            children: [
              SizedBox(
                width: 96,
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(isDense: true),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) widget.onChanged(n.clamp(15, 480));
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Text('menit (15–480)',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary)),
            ],
          ),
        ],
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.selected, required this.onTap});

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
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
