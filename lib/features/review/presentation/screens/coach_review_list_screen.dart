import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/review/data/models/coach_rating_aggregate.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/presentation/widgets/review_card.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';

class CoachReviewListScreen extends ConsumerStatefulWidget {
  final String coachId;

  const CoachReviewListScreen({super.key, required this.coachId});

  @override
  ConsumerState<CoachReviewListScreen> createState() =>
      _CoachReviewListScreenState();
}

class _CoachReviewListScreenState extends ConsumerState<CoachReviewListScreen> {
  int? _filterStar;

  @override
  Widget build(BuildContext context) {
    final reviewsAsync = ref.watch(coachReviewsProvider(widget.coachId));
    final ratingAsync = ref.watch(coachRatingProvider(widget.coachId));

    return Scaffold(
      appBar: AppBar(title: const Text('Ulasan Saya')),
      body: AsyncValueWidget(
        value: reviewsAsync,
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () {
            ref.invalidate(coachReviewsProvider(widget.coachId));
            ref.invalidate(coachRatingProvider(widget.coachId));
          },
        ),
        data: (reviews) {
          final filtered = _filterStar == null
              ? reviews
              : reviews.where((r) => r.rating == _filterStar).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Summary header
                ratingAsync.whenData((rating) => rating).whenOrNull(
                      data: (rating) => _buildSummaryCard(rating),
                    ) ??
                    const SizedBox.shrink(),

                const SizedBox(height: AppDimensions.base),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(null, 'Semua'),
                      for (var star = 5; star >= 1; star--)
                        _buildFilterChip(star, '$star★'),
                    ],
                  ),
                ),

                const SizedBox(height: AppDimensions.base),

                // Review list
                if (filtered.isEmpty)
                  _buildEmptyState()
                else
                  ...filtered.map((r) => ReviewCard(review: r)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(CoachRatingAggregate rating) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          // Average + stars
          Column(
            children: [
              Text(
                rating.averageRating.toStringAsFixed(1),
                style: AppTypography.displaySmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.neutral800,
                ),
              ),
              const SizedBox(height: AppDimensions.xs),
              RatingStars(
                rating: 0,
                showAverage: true,
                averageRating: rating.averageRating,
                size: 20,
              ),
              const SizedBox(height: AppDimensions.xs),
              Text(
                '${rating.totalReviews} ulasan',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.neutral500,
                ),
              ),
            ],
          ),
          const SizedBox(width: AppDimensions.xl),
          // Distribution bars
          Expanded(
            child: Column(
              children: [
                for (var star = 5; star >= 1; star--)
                  _buildDistributionRow(
                    star,
                    rating.distribution[star] ?? 0,
                    rating.totalReviews,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionRow(int star, int count, int total) {
    final fraction = total > 0 ? count / total : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              '$star',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.neutral500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
          const SizedBox(width: AppDimensions.xs),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 6,
                backgroundColor: AppColors.neutral100,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.accent),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          SizedBox(
            width: 24,
            child: Text(
              '$count',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.neutral400,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(int? star, String label) {
    final selected = _filterStar == star;
    return Padding(
      padding: const EdgeInsets.only(right: AppDimensions.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => setState(() => _filterStar = star),
        selectedColor: AppColors.primary50,
        labelStyle: AppTypography.labelMedium.copyWith(
          color: selected ? AppColors.primary700 : AppColors.neutral600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.massive),
        child: Column(
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: AppDimensions.iconXl,
              color: AppColors.neutral300,
            ),
            const SizedBox(height: AppDimensions.base),
            Text(
              'Belum ada ulasan',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.neutral400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
