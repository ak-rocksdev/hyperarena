import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

class RatingStars extends StatelessWidget {
  final int rating;
  final ValueChanged<int>? onRatingChanged;
  final double size;
  final bool showAverage;
  final double? averageRating;

  const RatingStars({
    super.key,
    required this.rating,
    this.onRatingChanged,
    this.size = 32,
    this.showAverage = false,
    this.averageRating,
  });

  bool get _isInteractive => onRatingChanged != null;

  @override
  Widget build(BuildContext context) {
    if (showAverage && averageRating != null) {
      return _buildAverageStars();
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: _isInteractive ? () => onRatingChanged!(starValue) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _isInteractive ? AppDimensions.xs : 1,
            ),
            child: Icon(
              starValue <= rating ? Icons.star_rounded : Icons.star_outline_rounded,
              color: starValue <= rating
                  ? AppColors.accent
                  : AppColors.neutral300,
              size: size,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAverageStars() {
    final avg = averageRating!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (avg >= starValue) {
          icon = Icons.star_rounded;
        } else if (avg >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Icon(
            icon,
            color: avg >= starValue - 0.5
                ? AppColors.accent
                : AppColors.neutral300,
            size: size,
          ),
        );
      }),
    );
  }
}
