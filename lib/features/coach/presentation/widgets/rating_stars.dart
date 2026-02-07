import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int maxStars;
  final double size;

  const RatingStars({
    super.key,
    required this.rating,
    this.maxStars = 5,
    this.size = 18,
  });

  @override
  Widget build(BuildContext context) {
    final ratingTheme = Theme.of(context).extension<RatingThemeExtension>()!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxStars, (index) {
        final starValue = index + 1;
        IconData icon;
        Color color;

        if (rating >= starValue) {
          icon = Icons.star_rounded;
          color = ratingTheme.starColor;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
          color = ratingTheme.halfStarColor;
        } else {
          icon = Icons.star_outline_rounded;
          color = ratingTheme.emptyStarColor;
        }

        return Icon(icon, color: color, size: size);
      }),
    );
  }
}
