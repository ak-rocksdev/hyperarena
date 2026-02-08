import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class CoachAvailabilityScreen extends ConsumerStatefulWidget {
  const CoachAvailabilityScreen({super.key});

  @override
  ConsumerState<CoachAvailabilityScreen> createState() =>
      _CoachAvailabilityScreenState();
}

class _CoachAvailabilityScreenState
    extends ConsumerState<CoachAvailabilityScreen> {
  static const _dayKeys = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

  static const _dayLabels = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  late Set<String> _selectedDays;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    final coach = MockData.coaches.firstWhere((c) => c.id == 'coach-001');
    _selectedDays = Set<String>.from(coach.availableDays);
    _startTime = _parseTime(coach.availableStartTime ?? '08:00');
    _endTime = _parseTime(coach.availableEndTime ?? '20:00');
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _buildPreview() {
    if (_selectedDays.isEmpty) return 'Tidak ada hari yang dipilih';

    final dayNames = <String>[];
    for (var i = 0; i < _dayKeys.length; i++) {
      if (_selectedDays.contains(_dayKeys[i])) {
        dayNames.add(_dayLabels[i]);
      }
    }

    return 'Tersedia: ${dayNames.join(', ')}, '
        '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
  }

  Future<void> _pickTime({required bool isStart}) async {
    final initial = isStart ? _startTime : _endTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Ketersediaan', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Day Selector ────────────────────────────────────
              Text('Hari Tersedia', style: AppTypography.titleSmall),
              const SizedBox(height: AppDimensions.md),
              Wrap(
                spacing: AppDimensions.sm,
                runSpacing: AppDimensions.sm,
                children: List.generate(_dayKeys.length, (i) {
                  final key = _dayKeys[i];
                  final isSelected = _selectedDays.contains(key);
                  return FilterChip(
                    label: Text(_dayLabels[i]),
                    selected: isSelected,
                    selectedColor: AppColors.primary100,
                    backgroundColor: AppColors.neutral100,
                    checkmarkColor: AppColors.primary,
                    labelStyle: AppTypography.bodySmall.copyWith(
                      color:
                          isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.neutral100,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(key);
                        } else {
                          _selectedDays.remove(key);
                        }
                      });
                    },
                  );
                }),
              ),

              const SizedBox(height: AppDimensions.xl),

              // ── Time Range ─────────────────────────────────────
              Text('Jam Operasional', style: AppTypography.titleSmall),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  Expanded(
                    child: _TimeTile(
                      label: 'Mulai',
                      time: _formatTime(_startTime),
                      onTap: () => _pickTime(isStart: true),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: _TimeTile(
                      label: 'Selesai',
                      time: _formatTime(_endTime),
                      onTap: () => _pickTime(isStart: false),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.xl),

              // ── Preview ────────────────────────────────────────
              Text('Preview', style: AppTypography.titleSmall),
              const SizedBox(height: AppDimensions.sm),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimensions.base),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Text(
                  _buildPreview(),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary800,
                  ),
                ),
              ),

              const Spacer(),

              // ── Save Button ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeightLg,
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ketersediaan berhasil disimpan'),
                      ),
                    );
                    context.pop();
                  },
                  child: const Text('Simpan Ketersediaan'),
                ),
              ),
              const SizedBox(height: AppDimensions.base),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Time Tile ──────────────────────────────────────────────────────────
class _TimeTile extends StatelessWidget {
  final String label;
  final String time;
  final VoidCallback onTap;

  const _TimeTile({
    required this.label,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.base,
          vertical: AppDimensions.md,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.neutral200),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              Icons.access_time,
              size: AppDimensions.iconSm,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppDimensions.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                Text(time, style: AppTypography.titleSmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
