import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';
import 'package:hyperarena/features/review/providers/venue_review_providers.dart';

class SubmitVenueReviewScreen extends ConsumerStatefulWidget {
  final String bookingId;

  const SubmitVenueReviewScreen({super.key, required this.bookingId});

  @override
  ConsumerState<SubmitVenueReviewScreen> createState() =>
      _SubmitVenueReviewScreenState();
}

class _SubmitVenueReviewScreenState
    extends ConsumerState<SubmitVenueReviewScreen> {
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
      final booking =
          MockData.bookings.firstWhere((b) => b.id == widget.bookingId);
      final repo = ref.read(venueReviewRepositoryProvider);
      await repo.submitVenueReview(
        venueId: booking.venueId ?? '',
        bookingId: widget.bookingId,
        rating: _rating,
        comment: _commentController.text.trim().isEmpty
            ? null
            : _commentController.text.trim(),
      );

      if (!mounted) return;

      // Invalidate related providers
      ref.invalidate(venueReviewsProvider(booking.venueId ?? ''));
      ref.invalidate(venueRatingProvider(booking.venueId ?? ''));
      ref.invalidate(
        hasReviewedBookingProvider(
          (reviewerId: 'user-001', bookingId: widget.bookingId),
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ulasan venue berhasil dikirim!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim ulasan: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = MockData.bookings.firstWhere(
      (b) => b.id == widget.bookingId,
      orElse: () => MockData.bookings.first,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Beri Ulasan Venue')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue info header
            Container(
              padding: const EdgeInsets.all(AppDimensions.base),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: AppShadows.sm,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: AppDimensions.avatarMd / 2,
                    backgroundColor: AppColors.primary100,
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary700,
                      size: AppDimensions.iconMd,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.venueName ?? '',
                          style: AppTypography.headingSmall,
                        ),
                        if (booking.courtName != null) ...[
                          const SizedBox(height: AppDimensions.xs),
                          Text(
                            booking.courtName!,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.neutral500,
                            ),
                          ),
                        ],
                        const SizedBox(height: AppDimensions.xxs),
                        Text(
                          Formatters.formatDate(booking.bookingDate),
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.neutral400,
                          ),
                        ),
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
                onRatingChanged: (value) =>
                    setState(() => _rating = value),
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
                hintText:
                    'Bagaimana pengalaman Anda di venue ini? Ceritakan tentang fasilitas, kebersihan, dan pelayanannya.',
                hintStyle: AppTypography.bodyMedium.copyWith(
                  color: AppColors.neutral400,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide:
                      const BorderSide(color: AppColors.neutral200),
                ),
              ),
            ),

            const SizedBox(height: AppDimensions.xxl),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'Kirim Ulasan',
                onPressed:
                    _rating > 0 && !_isSubmitting ? _submit : null,
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
