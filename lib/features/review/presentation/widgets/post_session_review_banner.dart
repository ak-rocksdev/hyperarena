import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/presentation/widgets/review_summary_card.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Post-session review entry point — shown on the session detail screen for
/// past sessions. Renders one of four states:
///
/// 1. **Has existing review** → [ReviewSummaryCard] (read-only).
/// 2. **No review + attended (`present`/`late`)** → enabled "Beri Ulasan" CTA.
/// 3. **No review + attendance not yet recorded** → disabled CTA + helper note
///    "Ulasan tersedia setelah absen tercatat di sesi ini."
/// 4. **No review + recorded `absent`** → hidden.
///
/// Pass [studentAttendanceStatus] from the parent (session detail) which has
/// the `attendances` array. `null` means status unknown (treated as state 3).
class PostSessionReviewBanner extends ConsumerWidget {
  final String sessionId;
  final String coachId;
  final String coachName;
  final String sessionTitle;
  final AttendanceStatus? studentAttendanceStatus;

  const PostSessionReviewBanner({
    super.key,
    required this.sessionId,
    required this.coachId,
    required this.coachName,
    required this.sessionTitle,
    this.studentAttendanceStatus,
  });

  bool get _attended =>
      studentAttendanceStatus == AttendanceStatus.present ||
      studentAttendanceStatus == AttendanceStatus.late;

  bool get _markedAbsent => studentAttendanceStatus == AttendanceStatus.absent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myReviewAsync = ref.watch(myReviewProvider(sessionId));

    return myReviewAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (review) {
        if (review != null) return ReviewSummaryCard(review: review);
        if (_markedAbsent) return const SizedBox.shrink();
        return _CtaBanner(
          coachName: coachName,
          enabled: _attended,
          onTap: _attended ? () => _navigateToReview(context) : null,
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

class _CtaBanner extends StatelessWidget {
  final String coachName;
  final bool enabled;
  final VoidCallback? onTap;

  const _CtaBanner({
    required this.coachName,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.base),
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [AppColors.accent50, AppColors.accent100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: enabled ? null : AppColors.neutral50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(
          color: enabled ? AppColors.accent200 : AppColors.neutral200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.avatarSm / 2,
                backgroundColor:
                    enabled ? AppColors.accent200 : AppColors.neutral200,
                child: Text(
                  coachName.isNotEmpty ? coachName[0].toUpperCase() : 'C',
                  style: AppTypography.labelMedium.copyWith(
                    color: enabled
                        ? AppColors.accent700
                        : AppColors.textTertiary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Text(
                  'Bagaimana latihan dengan $coachName?',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: enabled
                        ? AppColors.accent900
                        : AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.md),
          Row(
            children: [
              IgnorePointer(
                ignoring: !enabled,
                child: Opacity(
                  opacity: enabled ? 1 : 0.5,
                  child: RatingStars(
                    rating: 0,
                    size: 28,
                    onRatingChanged: (_) => onTap?.call(),
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onTap,
                child: Text(
                  'Beri Ulasan',
                  style: AppTypography.labelMedium.copyWith(
                    color: enabled
                        ? AppColors.accent700
                        : AppColors.textTertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (!enabled) ...[
            const SizedBox(height: AppDimensions.sm),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppDimensions.xs),
                Expanded(
                  child: Text(
                    'Ulasan tersedia setelah absen tercatat di sesi ini.',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
