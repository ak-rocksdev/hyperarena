import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';

/// Shimmer rows shown while a picker sheet's lookup (coaches, venues) loads —
/// mirrors the avatar + two-line layout of the real list tiles.
class PickerListSkeleton extends StatelessWidget {
  const PickerListSkeleton({super.key, this.rows = 6});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows,
      itemBuilder: (_, _) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.lg,
          vertical: AppDimensions.md,
        ),
        child: Row(
          children: [
            ShimmerLoading.circle(radius: 20),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoading.line(width: 140),
                  const SizedBox(height: 6),
                  ShimmerLoading.line(width: 90, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
