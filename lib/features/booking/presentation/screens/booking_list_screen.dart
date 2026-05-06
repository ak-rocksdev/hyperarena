import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/booking/data/models/marketplace_booking.dart';
import 'package:hyperarena/features/booking/providers/marketplace_booking_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Bookings tab — student's own enrolled sessions, cross-tenant.
/// Sourced from `GET /v1/marketplace/me/bookings?tab=upcoming|past` (Issue 14).
class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Saya'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Mendatang'),
              Tab(text: 'Selesai'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _BookingsTab(tab: BookingTab.upcoming),
            _BookingsTab(tab: BookingTab.past),
          ],
        ),
      ),
    );
  }
}

class _BookingsTab extends ConsumerWidget {
  final BookingTab tab;

  const _BookingsTab({required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(myBookingsProvider(tab));

    return RefreshIndicator(
      onRefresh: () => ref.refresh(myBookingsProvider(tab).future),
      child: async.when(
        loading: () => ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          itemCount: 3,
          itemBuilder: (_, _) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: ShimmerLoading.card(height: 140),
          ),
        ),
        error: (e, _) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.lg),
              child: ErrorView(
                error: e,
                onRetry: () => ref.invalidate(myBookingsProvider(tab)),
              ),
            ),
          ],
        ),
        data: (items) {
          if (items.isEmpty) {
            return ListView(
              children: [
                SizedBox(
                  height: 320,
                  child: EmptyState(
                    icon: Icons.calendar_today_outlined,
                    message: tab == BookingTab.upcoming
                        ? 'Belum ada sesi mendatang.'
                        : 'Belum ada riwayat sesi.',
                  ),
                ),
              ],
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            itemCount: items.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.md),
              child: _BookingCard(booking: items[i]),
            ),
          );
        },
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final MarketplaceBooking booking;

  const _BookingCard({required this.booking});

  String _paymentLabel() {
    return switch (booking.paymentStatus) {
      'pending_payment' => 'Menunggu Pembayaran',
      'pending_confirmation' => 'Menunggu Konfirmasi',
      'confirmed_transfer' => 'Lunas',
      'confirmed_credit' => 'Dibayar dengan kredit',
      _ => booking.paymentStatus ?? 'Status Tidak Diketahui',
    };
  }

  Color _paymentColor() {
    return switch (booking.paymentStatus) {
      'pending_payment' || 'pending_confirmation' => AppColors.warning,
      'confirmed_transfer' || 'confirmed_credit' => AppColors.success,
      _ => AppColors.textTertiary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final session = booking.session;
    final coach = session.coaches.isNotEmpty ? session.coaches.first : null;
    final localStart = session.startAt.toLocal();

    return InkWell(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
      onTap: () => context.push(AppRoutes.marketplaceSession(session.id)),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: AppShadows.sm,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    session.name,
                    style: AppTypography.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _paymentColor().withValues(alpha: 0.12),
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                  ),
                  child: Text(
                    _paymentLabel(),
                    style: AppTypography.caption.copyWith(
                      color: _paymentColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (session.tenant != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Text(
                'oleh ${session.tenant!.name}',
                style: AppTypography.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppDimensions.sm),
            Row(
              children: [
                Icon(Icons.schedule, size: 14, color: AppColors.neutral400),
                const SizedBox(width: 4),
                Text(
                  Formatters.formatDateTimeCompact(localStart),
                  style: AppTypography.bodySmall,
                ),
                const SizedBox(width: AppDimensions.md),
                Icon(Icons.timer_outlined,
                    size: 14, color: AppColors.neutral400),
                const SizedBox(width: 4),
                Text(
                  '${session.durationMinutes} menit',
                  style: AppTypography.bodySmall,
                ),
              ],
            ),
            if (session.venue != null) ...[
              const SizedBox(height: AppDimensions.xs),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: AppColors.neutral400),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      session.venue!.name,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (coach != null) ...[
              const SizedBox(height: AppDimensions.sm),
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundImage:
                        coach.photoUrl != null
                            ? NetworkImage(coach.photoUrl!)
                            : null,
                    backgroundColor: AppColors.primary50,
                    child: coach.photoUrl == null
                        ? Text(
                            Formatters.initials(coach.name),
                            style: AppTypography.caption.copyWith(
                              color: AppColors.primary,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: AppDimensions.sm),
                  Text(
                    coach.name,
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ],
            if (booking.canReview) ...[
              const SizedBox(height: AppDimensions.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.sm,
                  vertical: AppDimensions.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  border: Border.all(color: AppColors.accent200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star_outline,
                        size: 14, color: AppColors.accent700),
                    const SizedBox(width: AppDimensions.xs),
                    Text(
                      'Beri ulasan untuk coach',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accent700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
