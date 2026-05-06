import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/network/api_exceptions.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/booking/providers/marketplace_booking_providers.dart';
import 'package:hyperarena/features/profile/providers/career_provider.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class SubmitReviewScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String coachId;
  final String coachName;
  final String sessionTitle;
  final DateTime? sessionDate;

  const SubmitReviewScreen({
    super.key,
    required this.sessionId,
    required this.coachId,
    required this.coachName,
    required this.sessionTitle,
    this.sessionDate,
  });

  @override
  ConsumerState<SubmitReviewScreen> createState() => _SubmitReviewScreenState();
}

class _SubmitReviewScreenState extends ConsumerState<SubmitReviewScreen> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  /// Refetches caches that depend on review state so the previous screen
  /// renders the post-submit state immediately (no stale `can_review = true`
  /// until pull-to-refresh). Awaits the bookings tabs (the screen the user
  /// usually pops back to); the rest re-run lazily on next open.
  Future<void> _refreshDependentCaches() async {
    ref.invalidate(myReviewProvider(widget.sessionId));
    ref.invalidate(marketplaceSessionDetailProvider(widget.sessionId));
    // Both review-history providers hit the same endpoint but are distinct
    // Riverpod instances — invalidate both so the career screen and any
    // future review-list consumers stay in sync.
    ref.invalidate(playerWrittenReviewsProvider);
    ref.invalidate(myReviewsProvider);
    // Aggregate (avg + count + distribution) changes for the reviewed coach.
    ref.invalidate(coachRatingProvider(widget.coachId));

    Future<void> refetch(BookingTab tab) async {
      final future = ref.refresh(myBookingsProvider(tab).future);
      try {
        await future;
      } catch (_) {
        // Swallow refetch errors — pop should not be blocked by a transient
        // failure on the bookings list.
      }
    }

    await Future.wait<void>([
      refetch(BookingTab.upcoming),
      refetch(BookingTab.past),
    ]);
  }

  Future<void> _completeAndPop({String? snackbar}) async {
    setState(() => _submitted = true);
    // Run the success-state dwell in parallel with the refetch so total
    // perceived latency is max(animation, network), not their sum.
    await Future.wait<void>([
      Future<void>.delayed(const Duration(milliseconds: 900)),
      _refreshDependentCaches(),
    ]);
    if (!mounted) return;
    if (snackbar != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbar),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    context.pop();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitted) return;
    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.submitReview(
        coachId: widget.coachId,
        sessionId: widget.sessionId,
        rating: _rating,
        comment: Formatters.nullIfEmpty(_commentController.text.trim()),
      );
      await _completeAndPop();
    } on ConflictException {
      // Already-reviewed: treat as success so the user reaches the same
      // post-submit state instead of a misleading error.
      await _completeAndPop(
        snackbar: 'Ulasan untuk sesi ini sudah pernah dikirim.',
      );
    } on ForbiddenException catch (e) {
      _showError(e.message.isNotEmpty
          ? e.message
          : 'Hanya peserta sesi yang dapat memberi ulasan.');
    } on ValidationException catch (e) {
      _showError(e.message.isNotEmpty
          ? e.message
          : 'Periksa kembali rating atau komentar Anda.');
    } on NotFoundException catch (_) {
      _showError('Sesi tidak ditemukan.');
    } on ApiException catch (e) {
      _showError(e.message.isNotEmpty ? e.message : 'Gagal mengirim ulasan.');
    } catch (_) {
      _showError('Gagal mengirim ulasan. Coba lagi.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beri Ulasan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach info header
            Container(
              padding: const EdgeInsets.all(AppDimensions.base),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: AppShadows.sm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppDimensions.avatarMd / 2,
                    backgroundColor: AppColors.primary100,
                    child: Text(
                      widget.coachName.isNotEmpty
                          ? widget.coachName[0].toUpperCase()
                          : 'C',
                      style: AppTypography.headingMedium.copyWith(
                        color: AppColors.primary700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.coachName,
                          style: AppTypography.headingSmall,
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          widget.sessionTitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.neutral500,
                          ),
                        ),
                        if (widget.sessionDate != null) ...[
                          const SizedBox(height: AppDimensions.xxs),
                          Text(
                            Formatters.formatDate(widget.sessionDate!),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.neutral400,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.xl),

            // Star rating
            Text('Berikan Rating', style: AppTypography.headingSmall),
            const SizedBox(height: AppDimensions.md),
            Center(
              child: RatingStars(
                rating: _rating,
                onRatingChanged: (value) => setState(() => _rating = value),
                size: 44,
              ),
            ),
            if (_rating > 0) ...[
              const SizedBox(height: AppDimensions.sm),
              Center(
                child: Text(
                  _ratingLabel(_rating),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.accent600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],

            const SizedBox(height: AppDimensions.xl),

            // Comment field
            Text('Komentar (Opsional)', style: AppTypography.headingSmall),
            const SizedBox(height: AppDimensions.sm),
            TextField(
              controller: _commentController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: 'Bagaimana pengalaman latihan dengan coach ini?',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutral400,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: const BorderSide(color: AppColors.neutral200),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.md),

            // Privacy notice
            Container(
              padding: const EdgeInsets.all(AppDimensions.md),
              decoration: BoxDecoration(
                color: AppColors.neutral50,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    size: AppDimensions.iconSm,
                    color: AppColors.neutral400,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Expanded(
                    child: Text(
                      'Ulasan ini hanya dapat dilihat oleh Anda dan admin. '
                      'Coach tidak melihat ulasan secara langsung.',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.neutral500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.xxl),

            SizedBox(
              width: double.infinity,
              child: _submitted
                  ? _buildSentBanner()
                  : AppButton(
                      label: 'Kirim Ulasan',
                      onPressed: _rating > 0 && !_isSubmitting ? _submit : null,
                      isLoading: _isSubmitting,
                      isLarge: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(int rating) => switch (rating) {
        1 => 'Sangat Kurang',
        2 => 'Kurang',
        3 => 'Cukup',
        4 => 'Baik',
        5 => 'Sangat Baik',
        _ => '',
      };

  // Inline post-submit confirmation; visible for ~900ms before the screen pops.
  Widget _buildSentBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.base,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: AppDimensions.iconMd,
          ),
          const SizedBox(width: AppDimensions.sm),
          Text(
            'Ulasan terkirim. Terima kasih.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
