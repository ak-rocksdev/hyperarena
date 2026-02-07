import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/booking/presentation/widgets/booking_card.dart';
import 'package:hyperarena/features/booking/providers/booking_providers.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final bookingsAsync = ref.watch(bookingListProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.base),

              // Greeting
              Text(
                '${_greeting()},',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                user?.name ?? 'Player',
                style: AppTypography.headingLarge,
              ),
              const SizedBox(height: AppDimensions.xl),

              // Hero CTA card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusLg),
                  boxShadow: AppShadows.colored,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusLg),
                    onTap: () => context.go('/player/explore'),
                    child: Padding(
                      padding: const EdgeInsets.all(AppDimensions.lg),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 48,
                            color: AppColors.textOnPrimary,
                          ),
                          const SizedBox(width: AppDimensions.base),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cari Lapangan',
                                  style: AppTypography.titleMedium
                                      .copyWith(
                                    color: AppColors.textOnPrimary,
                                  ),
                                ),
                                const SizedBox(
                                    height: AppDimensions.xxs),
                                Text(
                                  'Temukan venue terdekat',
                                  style: AppTypography.bodySmall
                                      .copyWith(
                                    color: AppColors.textOnPrimary
                                        .withValues(alpha: 0.80),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.textOnPrimary
                                .withValues(alpha: 0.60),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // Sport quick-access
              Text('Olahraga', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              SizedBox(
                height: AppDimensions.chipHeight + 8,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: Sport.values.map((sport) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: AppDimensions.sm),
                      child: SportChipSelector(
                        sport: sport,
                        isSelected: false,
                        onToggle: (_) {
                          ref
                              .read(venueFilterProvider.notifier)
                              .setSport(sport);
                          context.go('/player/explore');
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.xl),

              // Upcoming booking
              Text('Booking Mendatang', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              bookingsAsync.when(
                loading: () => const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (_, _) => const SizedBox.shrink(),
                data: (bookings) {
                  final upcoming = bookings
                      .where((b) =>
                          b.status == BookingStatus.pendingPayment ||
                          b.status == BookingStatus.waitingConfirmation ||
                          b.status == BookingStatus.confirmed)
                      .toList();
                  if (upcoming.isEmpty) {
                    return Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.all(AppDimensions.xl),
                      decoration: BoxDecoration(
                        color: AppSurfaces.surfaceHighlight,
                        borderRadius: BorderRadius.circular(
                            AppDimensions.radiusLg),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: AppColors.primary300,
                            size: 32,
                          ),
                          const SizedBox(height: AppDimensions.sm),
                          Text(
                            'Belum ada booking mendatang',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg),
                      boxShadow: AppShadows.sm,
                    ),
                    child: BookingCard(booking: upcoming.first),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
