import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

class FacilityChips extends StatelessWidget {
  final List<String> facilities;

  const FacilityChips({super.key, required this.facilities});

  static IconData _icon(String facility) => switch (facility) {
        'parking' => Icons.local_parking,
        'shower' => Icons.shower,
        'wifi' => Icons.wifi,
        'canteen' => Icons.restaurant,
        'locker' => Icons.lock,
        _ => Icons.check_circle_outline,
      };

  static String _label(String facility) => switch (facility) {
        'parking' => 'Parkir',
        'shower' => 'Shower',
        'wifi' => 'WiFi',
        'canteen' => 'Kantin',
        'locker' => 'Loker',
        _ => facility,
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.xs,
      children: facilities.map((f) {
        return Chip(
          avatar: Icon(_icon(f), size: 16),
          label: Text(_label(f)),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }
}
