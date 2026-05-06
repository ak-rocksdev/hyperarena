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
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/providers/review_providers.dart';

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

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;
    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(reviewRepositoryProvider);
      await repo.submitReview(
        coachId: widget.coachId,
        sessionId: widget.sessionId,
        rating: _rating,
        comment: Formatters.nullIfEmpty(_commentController.text.trim()),
      );

      // Refresh the per-session provider so the calling screen renders the
      // read-only summary card on return.
      ref.invalidate(myReviewProvider(widget.sessionId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan berhasil dikirim!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } on ConflictException catch (e) {
      _showError(e.message.isNotEmpty
          ? e.message
          : 'Anda sudah memberi ulasan untuk sesi ini.');
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

            // Submit button
            SizedBox(
              width: double.infinity,
              child: AppButton(
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
}
