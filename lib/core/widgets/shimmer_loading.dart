import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder widgets for loading states.
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  /// Rectangular card placeholder.
  factory ShimmerLoading.card({Key? key, double height = 120}) {
    return ShimmerLoading(
      key: key,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  /// Line placeholder (e.g. text line).
  factory ShimmerLoading.line({
    Key? key,
    double? width,
    double height = 14,
  }) {
    return ShimmerLoading(
      key: key,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
        ),
      ),
    );
  }

  /// Circle placeholder (e.g. avatar).
  factory ShimmerLoading.circle({Key? key, double radius = 24}) {
    return ShimmerLoading(
      key: key,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppSurfaces.shimmerBase,
      highlightColor: AppSurfaces.shimmerHighlight,
      child: child,
    );
  }
}
