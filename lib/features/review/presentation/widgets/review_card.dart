import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';

/// Renders a single [Review] in list contexts (admin coach detail or student
/// review history). Relies on list-endpoint responses to populate
/// `coachName`/`sessionTitle`/`sessionDate`.
class ReviewCard extends StatefulWidget {
  final Review review;

  /// Optional student-side label for admin context. When provided, renders
  /// alongside the coach label so admins can attribute the review.
  final String? studentName;

  const ReviewCard({super.key, required this.review, this.studentName});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final headerLabel = widget.studentName ?? r.coachName ?? 'Ulasan';
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.avatarSm / 2,
                backgroundColor: AppColors.primary50,
                child: Text(
                  headerLabel.isNotEmpty
                      ? headerLabel[0].toUpperCase()
                      : '?',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary700,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  headerLabel,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                Formatters.formatDate(r.createdAt),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.sm),
          RatingStars(rating: r.rating, size: 18),

          if (r.sessionTitle != null) ...[
            const SizedBox(height: AppDimensions.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.sm,
                vertical: AppDimensions.xs,
              ),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.event_outlined,
                    size: AppDimensions.iconXs,
                    color: AppColors.neutral500,
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Flexible(
                    child: Text(
                      r.sessionTitle!,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.neutral500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (r.comment != null && r.comment!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.md),
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Text(
                r.comment!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.neutral600,
                ),
                maxLines: _expanded ? null : 3,
                overflow: _expanded ? null : TextOverflow.ellipsis,
              ),
            ),
            if (!_expanded && r.comment!.length > 120)
              GestureDetector(
                onTap: () => setState(() => _expanded = true),
                child: Padding(
                  padding: const EdgeInsets.only(top: AppDimensions.xs),
                  child: Text(
                    'Selengkapnya',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
