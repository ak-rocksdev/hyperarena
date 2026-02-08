import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class PostSessionReviewBanner extends ConsumerWidget {
  final String sessionId;
  final String coachId;
  final String coachName;
  final String sessionTitle;
  final String currentPlayerId;

  const PostSessionReviewBanner({
    super.key,
    required this.sessionId,
    required this.coachId,
    required this.coachName,
    required this.sessionTitle,
    required this.currentPlayerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasReviewedAsync = ref.watch(
      hasReviewedProvider(
        (reviewerId: currentPlayerId, sessionId: sessionId),
      ),
    );

    return hasReviewedAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (hasReviewed) {
        if (hasReviewed) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: AppDimensions.base),
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.accent50, AppColors.accent100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(color: AppColors.accent200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: AppDimensions.avatarSm / 2,
                    backgroundColor: AppColors.accent200,
                    child: Text(
                      coachName.isNotEmpty ? coachName[0].toUpperCase() : 'C',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accent700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Text(
                      'Bagaimana latihan dengan $coachName?',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.md),
              Row(
                children: [
                  RatingStars(
                    rating: 0,
                    size: 28,
                    onRatingChanged: (_) => _navigateToReview(context),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _navigateToReview(context),
                    child: Text(
                      'Beri Ulasan',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.accent700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToReview(BuildContext context) {
    final path = AppRoutes.submitReview(sessionId);
    context.push(
      '$path?coachId=$coachId&coachName=${Uri.encodeComponent(coachName)}&sessionTitle=${Uri.encodeComponent(sessionTitle)}',
    );
  }
}
