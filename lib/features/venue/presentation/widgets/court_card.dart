import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

class CourtCard extends ConsumerWidget {
  final Court court;
  final Venue venue;

  const CourtCard({super.key, required this.court, required this.venue});

  String _envLabel(String env) => switch (env) {
        'indoor' => 'Indoor',
        'outdoor' => 'Outdoor',
        'covered' => 'Covered',
        _ => env,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(court.name, style: AppTypography.titleSmall),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: sportTheme.backgroundColor(court.sportType),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusXs),
                        ),
                        child: Text(
                          SportChipSelector.sportLabel(court.sportType),
                          style: AppTypography.badge.copyWith(
                            color: sportTheme.textColor(court.sportType),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.sm),
                      if (court.surfaceType != null)
                        Text(
                          court.surfaceType!.replaceAll('_', ' '),
                          style: AppTypography.caption,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  Row(
                    children: [
                      Icon(
                        court.environment == 'indoor'
                            ? Icons.roofing
                            : Icons.wb_sunny_outlined,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _envLabel(court.environment),
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AppButton(
              label: 'Booking',
              variant: AppButtonVariant.elevated,
              onPressed: () {
                ref.read(bookingFlowProvider.notifier).selectCourt(court, venue);
                context.push('/booking/flow/court/${court.id}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
