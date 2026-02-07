import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';

/// Styled FilterChip for selecting a sport, colored via SportThemeExtension.
class SportChipSelector extends StatelessWidget {
  final Sport sport;
  final bool isSelected;
  final ValueChanged<bool> onToggle;

  const SportChipSelector({
    super.key,
    required this.sport,
    required this.isSelected,
    required this.onToggle,
  });

  static IconData sportIcon(Sport sport) => switch (sport) {
        Sport.tennis => Icons.sports_tennis,
        Sport.badminton => Icons.sports,
        Sport.futsal => Icons.sports_soccer,
        Sport.basketball => Icons.sports_basketball,
        Sport.volleyball => Icons.sports_volleyball,
        Sport.padel => Icons.sports_tennis,
        Sport.tableTennis => Icons.sports,
      };

  static String sportLabel(Sport sport) => switch (sport) {
        Sport.tennis => 'Tenis',
        Sport.padel => 'Padel',
        Sport.badminton => 'Badminton',
        Sport.futsal => 'Futsal',
        Sport.basketball => 'Basket',
        Sport.volleyball => 'Voli',
        Sport.tableTennis => 'Tenis Meja',
      };

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;

    return FilterChip(
      selected: isSelected,
      label: Text(sportLabel(sport)),
      avatar: Icon(sportIcon(sport), size: 18),
      selectedColor: sportTheme.backgroundColor(sport),
      checkmarkColor: sportTheme.color(sport),
      onSelected: onToggle,
    );
  }
}
