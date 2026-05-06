import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/presentation/widgets/review_summary_card.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Post-session review entry point — shown on the session detail screen for
/// past sessions. State is server-driven via [canReview] + [blockedReason]
/// from `GET /v1/marketplace/sessions/{id}` `user_status` block (Issue 16):
///
/// - `already_reviewed` → [ReviewSummaryCard] (read-only).
/// - `null` (canReview=true) → enabled "Beri Ulasan" CTA.
/// - `session_not_ended` → disabled CTA + "Ulasan tersedia setelah sesi selesai".
/// - `not_attended` → disabled CTA + "Hanya peserta yang hadir dapat memberi ulasan".
class PostSessionReviewBanner extends ConsumerWidget {
  final String sessionId;
  final String coachId;
  final String coachName;
  final String sessionTitle;
  final bool canReview;
  final String? blockedReason;

  const PostSessionReviewBanner({
    super.key,
    required this.sessionId,
    required this.coachId,
    required this.coachName,
    required this.sessionTitle,
    this.canReview = false,
    this.blockedReason,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (blockedReason == 'already_reviewed') {
      final myReviewAsync = ref.watch(myReviewProvider(sessionId));
      return myReviewAsync.when(
        loading: () => const SizedBox.shrink(),
        error: (_, _) => const SizedBox.shrink(),
        data: (review) => review != null
            ? ReviewSummaryCard(review: review)
            : const SizedBox.shrink(),
      );
    }

    return _CtaBanner(
      coachName: coachName,
      enabled: canReview,
      blockedNote: _blockedNote(),
      onTap: canReview ? () => _navigateToReview(context) : null,
    );
  }

  String? _blockedNote() => switch (blockedReason) {
        'session_not_ended' => 'Ulasan tersedia setelah sesi selesai.',
        'not_attended' =>
          'Hanya peserta yang hadir dapat memberi ulasan.',
        _ => null,
      };

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
  final String? blockedNote;
  final VoidCallback? onTap;

  const _CtaBanner({
    required this.coachName,
    required this.enabled,
    required this.onTap,
    this.blockedNote,
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
          if (!enabled && blockedNote != null) ...[
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
                    blockedNote!,
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
