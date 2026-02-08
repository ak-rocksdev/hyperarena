import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/review/providers/venue_review_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class PostBookingReviewBanner extends ConsumerWidget {
  final String bookingId;
  final String venueName;

  const PostBookingReviewBanner({
    super.key,
    required this.bookingId,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasReviewedAsync = ref.watch(
      hasReviewedBookingProvider(
        (reviewerId: 'user-001', bookingId: bookingId),
      ),
    );

    return hasReviewedAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (hasReviewed) {
        if (hasReviewed) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.md),
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.accent.withValues(alpha: 0.08),
                AppColors.accent.withValues(alpha: 0.03),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.rate_review_outlined,
                    color: AppColors.accent600,
                    size: AppDimensions.iconMd,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      'Bagaimana pengalaman di $venueName?',
                      style: AppTypography.titleSmall.copyWith(
                        color: AppColors.accent600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.push(
                    AppRoutes.submitVenueReview(bookingId),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMd,
                      ),
                    ),
                  ),
                  child: const Text('Beri Ulasan'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
