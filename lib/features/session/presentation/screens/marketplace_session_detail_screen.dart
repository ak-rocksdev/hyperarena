import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session_detail.dart';
import 'package:hyperarena/features/session/data/models/tenant_payment_info.dart';
import 'package:hyperarena/features/session/presentation/widgets/credit_confirmation_sheet.dart';
import 'package:hyperarena/features/session/providers/marketplace_session_join_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:intl/intl.dart';

/// Marketplace session detail screen.
/// Fetches enriched data via [marketplaceSessionDetailProvider].
class MarketplaceSessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const MarketplaceSessionDetailScreen({super.key, required this.sessionId});

  static final _dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id');
  static final _timeFormat = DateFormat('HH:mm', 'id');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncDetail = ref.watch(marketplaceSessionDetailProvider(sessionId));

    return asyncDetail.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimensions.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                const SizedBox(height: AppDimensions.md),
                Text(
                  'Gagal memuat detail sesi',
                  style: AppTypography.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  error.toString(),
                  style: AppTypography.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.lg),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(marketplaceSessionDetailProvider(sessionId)),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (detail) => _DetailBody(
        detail: detail,
        sessionId: sessionId,
      ),
    );
  }
}

// ── Main body (loaded state) ──────────────────────────────────

class _DetailBody extends ConsumerWidget {
  final MarketplaceSessionDetail detail;
  final String sessionId;

  const _DetailBody({required this.detail, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = detail.session;
    final pricing = detail.pricing;
    final userStatus = detail.userStatus;

    final localStart = session.startAt.toLocal();
    final localEnd = localStart.add(Duration(minutes: session.durationMinutes));
    final spotsLeft = session.capacity - session.bookedCount;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: AppColors.primary700,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppSurfaces.primaryGradient,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppDimensions.huge),
                      Icon(
                        session.type == 'private' ? Icons.person : Icons.groups,
                        size: 56,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        session.type == 'private' ? 'Sesi Privat' : 'Sesi Grup',
                        style: AppTypography.titleMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Session name
                  Text(session.name, style: AppTypography.headingLarge),

                  if (session.tenant != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'oleh ${session.tenant!.name}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.lg),

                  // Date & time card
                  _InfoCard(
                    icon: Icons.calendar_today,
                    title: MarketplaceSessionDetailScreen._dateFormat
                        .format(localStart),
                    subtitle:
                        '${MarketplaceSessionDetailScreen._timeFormat.format(localStart)} – ${MarketplaceSessionDetailScreen._timeFormat.format(localEnd)} (${session.durationMinutes} menit)',
                  ),
                  const SizedBox(height: AppDimensions.md),

                  // Capacity card
                  _InfoCard(
                    icon: Icons.groups_outlined,
                    title: '${session.bookedCount}/${session.capacity} peserta',
                    subtitle:
                        spotsLeft > 0 ? '$spotsLeft slot tersedia' : 'Sesi penuh',
                    accentColor:
                        spotsLeft > 0 ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(height: AppDimensions.lg),

                  // Venue section
                  if (session.venue != null)
                    VenueLocationSection(
                      venueName: session.venue!.name,
                      address: session.venue!.location?.address,
                      lat: session.venue!.location?.lat,
                      lng: session.venue!.location?.lng,
                    ),

                  // Coaches section
                  if (session.coaches.isNotEmpty) ...[
                    Text('Pelatih', style: AppTypography.headingSmall),
                    const SizedBox(height: AppDimensions.md),
                    ...session.coaches.map(
                      (coach) => _CoachRow(coach: coach),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],

                  // Participants section (horizontal wrap grid)
                  _ParticipantsGrid(
                    participants: session.participants,
                    capacity: session.capacity,
                  ),

                  // Notes section
                  if (session.notes != null && session.notes!.isNotEmpty) ...[
                    Text('Catatan', style: AppTypography.headingSmall),
                    const SizedBox(height: AppDimensions.sm),
                    Text(
                      session.notes!,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],

                  // Extra bottom padding so content isn't hidden behind bottom bar
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        pricing: pricing,
        userStatus: userStatus,
        session: session,
        sessionId: sessionId,
        tenantPayment: detail.tenantPayment,
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? accentColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? AppColors.primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.titleSmall),
                Text(
                  subtitle,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Coach row ─────────────────────────────────────────────────

class _CoachRow extends StatelessWidget {
  final SessionCoach coach;

  const _CoachRow({required this.coach});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: coach.user?.photoUrls?['sm'] != null
                ? NetworkImage(coach.user!.photoUrls!['sm']!)
                : null,
            child: coach.user?.photoUrls == null
                ? const Icon(Icons.person, size: 20)
                : null,
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Text(
              coach.user?.name ?? 'Coach',
              style: AppTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Participants grid (horizontal wrap) ───────────────────────

class _ParticipantsGrid extends StatelessWidget {
  final List<SessionParticipant> participants;
  final int capacity;

  const _ParticipantsGrid({
    required this.participants,
    required this.capacity,
  });

  @override
  Widget build(BuildContext context) {
    final emptySlots = capacity - participants.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Peserta (${participants.length}/$capacity)',
          style: AppTypography.headingSmall,
        ),
        const SizedBox(height: AppDimensions.md),
        Wrap(
          spacing: AppDimensions.sm,
          runSpacing: AppDimensions.sm,
          children: [
            // Enrolled participants
            ...participants.map((p) => _ParticipantAvatar(name: p.name)),
            // Empty slots
            for (int i = 0; i < emptySlots; i++) const _EmptySlotAvatar(),
          ],
        ),
        const SizedBox(height: AppDimensions.lg),
      ],
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  final String name;

  const _ParticipantAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Tooltip(
      message: name,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        child: Text(
          initial,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}

class _EmptySlotAvatar extends StatelessWidget {
  const _EmptySlotAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.neutral400,
          width: 1,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: const Icon(
        Icons.person_outline,
        size: 18,
        color: AppColors.neutral400,
      ),
    );
  }
}

// ── Bottom bar ────────────────────────────────────────────────

class _BottomBar extends ConsumerWidget {
  final SessionPricing pricing;
  final UserSessionStatus userStatus;
  final MarketplaceSession session;
  final String sessionId;
  final TenantPaymentInfo tenantPayment;

  const _BottomBar({
    required this.pricing,
    required this.userStatus,
    required this.session,
    required this.sessionId,
    required this.tenantPayment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joinState = ref.watch(marketplaceSessionJoinProvider);
    final isFull = session.bookedCount >= session.capacity;

    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.screenHorizontal,
        right: AppDimensions.screenHorizontal,
        top: AppDimensions.md,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        border: const Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Price column
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biaya per orang',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  Formatters.formatRupiah(pricing.price),
                  style: AppTypography.price,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.md),

          // Action button
          _buildActionButton(context, ref, joinState, isFull),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    MarketplaceSessionJoinState joinState,
    bool isFull,
  ) {
    // Already booked
    if (userStatus.isBooked) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.success,
          disabledBackgroundColor: AppColors.success.withValues(alpha: 0.6),
          minimumSize: const Size(160, AppDimensions.buttonHeightMd),
        ),
        child: Text(
          'Sudah Terdaftar',
          style: AppTypography.button.copyWith(color: Colors.white),
        ),
      );
    }

    // Session full
    if (isFull) {
      return FilledButton(
        onPressed: null,
        style: FilledButton.styleFrom(
          minimumSize: const Size(160, AppDimensions.buttonHeightMd),
        ),
        child: const Text('Sesi Penuh'),
      );
    }

    // Has credits — show badge
    if (userStatus.creditBalance >= 1) {
      return FilledButton(
        onPressed: joinState.isLoading ? null : () => _onJoinTap(context, ref),
        style: FilledButton.styleFrom(
          minimumSize: const Size(160, AppDimensions.buttonHeightMd),
        ),
        child: joinState.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Gabung Sekarang'),
                  const SizedBox(width: AppDimensions.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusFull),
                    ),
                    child: Text(
                      '${userStatus.creditBalance} kredit',
                      style: AppTypography.badge.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
      );
    }

    // No credits — normal join
    return FilledButton(
      onPressed: joinState.isLoading ? null : () => _onJoinTap(context, ref),
      style: FilledButton.styleFrom(
        minimumSize: const Size(160, AppDimensions.buttonHeightMd),
      ),
      child: joinState.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : const Text('Gabung Sekarang'),
    );
  }

  Future<void> _onJoinTap(BuildContext context, WidgetRef ref) async {
    if (userStatus.creditBalance >= 1) {
      // Show credit confirmation sheet
      final confirmed = await showCreditConfirmationSheet(
        context: context,
        creditBalance: userStatus.creditBalance,
      );
      if (confirmed != true || !context.mounted) return;
    }

    // Call join API
    final notifier = ref.read(marketplaceSessionJoinProvider.notifier);
    final response = await notifier.join(int.parse(sessionId));
    if (!context.mounted) return;

    if (response == null) {
      final error =
          ref.read(marketplaceSessionJoinProvider).error ?? 'Gagal bergabung';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    // Navigate based on result
    if (response.usedCredit) {
      context.go(
        AppRoutes.marketplaceSessionConfirmation(sessionId),
        extra: {
          'sessionName': session.name,
          'price': pricing.price,
        },
      );
    } else {
      context.go(
        AppRoutes.marketplaceSessionPayment(sessionId),
        extra: {
          'joinResponse': response,
          'tenantPayment': tenantPayment,
          'sessionName': session.name,
          'price': pricing.price,
        },
      );
    }
  }
}
