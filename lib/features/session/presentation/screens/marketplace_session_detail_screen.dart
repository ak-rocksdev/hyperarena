import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/review/presentation/widgets/post_session_review_banner.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session.dart';
import 'package:hyperarena/features/session/data/models/marketplace_session_detail.dart';
import 'package:hyperarena/features/session/data/models/tenant_payment_info.dart';
import 'package:hyperarena/features/session/presentation/widgets/credit_confirmation_sheet.dart';
import 'package:hyperarena/features/session/providers/marketplace_session_join_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';
import 'package:hyperarena/core/utils/formatters.dart';

/// Marketplace session detail screen.
/// Fetches enriched data via [marketplaceSessionDetailProvider].
///
/// Handles the `?joined=1` query parameter injected by [PaymentSuccessScreen]
/// to show a success snackbar and pulse-highlight the newest participant row.
class MarketplaceSessionDetailScreen extends ConsumerStatefulWidget {
  final String sessionId;

  const MarketplaceSessionDetailScreen({super.key, required this.sessionId});

  @override
  ConsumerState<MarketplaceSessionDetailScreen> createState() =>
      _MarketplaceSessionDetailScreenState();
}

class _MarketplaceSessionDetailScreenState
    extends ConsumerState<MarketplaceSessionDetailScreen> {
  /// True for the first render after arriving via ?joined=1.
  /// Cleared after the first frame so back-and-forth doesn't repeat the UX.
  bool _highlightJoined = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final justJoined =
          GoRouterState.of(context).uri.queryParameters['joined'] == '1';
      if (justJoined) {
        _showJoinSuccess();
        setState(() => _highlightJoined = true);
        // Clear flag after animation has had time to play (1.5 s)
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (mounted) setState(() => _highlightJoined = false);
        });
      }
    });
  }

  void _showJoinSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text('Anda berhasil bergabung di sesi ini!'),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncDetail =
        ref.watch(marketplaceSessionDetailProvider(widget.sessionId));

    return asyncDetail.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenHorizontal),
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
                  onPressed: () => ref.invalidate(
                      marketplaceSessionDetailProvider(widget.sessionId)),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          ),
        ),
      ),
      data: (detail) => _DetailBody(
        detail: detail,
        sessionId: widget.sessionId,
        highlightJoined: _highlightJoined,
      ),
    );
  }
}

// ── Main body (loaded state) ──────────────────────────────────

class _DetailBody extends ConsumerWidget {
  final MarketplaceSessionDetail detail;
  final String sessionId;
  final bool highlightJoined;

  const _DetailBody({
    required this.detail,
    required this.sessionId,
    required this.highlightJoined,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = detail.session;
    final pricing = detail.pricing;
    final userStatus = detail.userStatus;

    final localStart = session.startAt;
    final localEnd = localStart.add(Duration(minutes: session.durationMinutes));
    final spotsLeft = session.capacity - session.bookedCount;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.primary700,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: SessionHero(
                photoUrls: session.photoUrls,
                photoPath: session.photoPath,
                size: SessionHeroSize.lg,
                brandColor: session.tenant?.brandColor,
                borderRadius: 0,
                enableZoom: true,
                heroTag: 'marketplace-session-hero-$sessionId',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.safeTitle, style: AppTypography.headingLarge),

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
                    title: Formatters.formatDateLong(localStart),
                    subtitle:
                        '${Formatters.formatTimeHm(localStart)} – ${Formatters.formatTimeHm(localEnd)} (${session.durationMinutes} menit)',
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

                  // Review banner — server-driven via user_status.can_review
                  // and review_blocked_reason (Issue 16). Show whenever the
                  // user is booked and there's at least one coach to review.
                  if (userStatus.isBooked && session.coaches.isNotEmpty) ...[
                    PostSessionReviewBanner(
                      sessionId: sessionId,
                      coachId: session.coaches.first.id,
                      coachName: session.coaches.first.user?.name ?? 'Coach',
                      sessionTitle: session.safeTitle,
                      canReview: userStatus.canReview,
                      blockedReason: userStatus.reviewBlockedReason,
                    ),
                    const SizedBox(height: AppDimensions.lg),
                  ],

                  // Participants section (horizontal wrap grid)
                  _ParticipantsGrid(
                    participants: session.participants,
                    capacity: session.capacity,
                    highlightJoined: highlightJoined,
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
  final bool highlightJoined;

  const _ParticipantsGrid({
    required this.participants,
    required this.capacity,
    required this.highlightJoined,
  });

  @override
  Widget build(BuildContext context) {
    final emptySlots = capacity - participants.length;

    // The most recently joined participant is the last in the list (BE appends
    // in join order). We highlight that slot when arriving via ?joined=1.
    final lastIndex = participants.length - 1;

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
            ...participants.indexed.map((entry) {
              final (index, p) = entry;
              final isNewJoin = highlightJoined && index == lastIndex;
              return _PulseHighlight(
                enabled: isNewJoin,
                child: _ParticipantAvatar(name: p.name, photoUrl: p.photoUrl),
              );
            }),
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
  final String? photoUrl;

  const _ParticipantAvatar({required this.name, this.photoUrl});

  @override
  Widget build(BuildContext context) {
    final initial = Formatters.initials(name);
    return Tooltip(
      message: name,
      child: CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        backgroundImage:
            photoUrl != null ? NetworkImage(photoUrl!) : null,
        child: photoUrl == null
            ? Text(
                initial,
                style: AppTypography.labelMedium
                    .copyWith(color: AppColors.primary),
              )
            : null,
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

// ── Pulse highlight wrapper ────────────────────────────────────

/// Wraps [child] in a one-shot background color animation that fades from
/// [AppColors.primary50] to transparent over 1200 ms. Only active when
/// [enabled] is true; renders [child] directly otherwise.
class _PulseHighlight extends StatefulWidget {
  const _PulseHighlight({required this.child, required this.enabled});

  final Widget child;
  final bool enabled;

  @override
  State<_PulseHighlight> createState() => _PulseHighlightState();
}

class _PulseHighlightState extends State<_PulseHighlight>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _bgColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _bgColor = ColorTween(
      begin: AppColors.primary50,
      end: Colors.transparent,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    if (widget.enabled) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return AnimatedBuilder(
      animation: _bgColor,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          color: _bgColor.value,
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      ),
      child: widget.child,
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
    final currency = ref.watch(tenantCurrencyProvider);
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
                  Formatters.sessionPriceLabel(
                    effectivePrice: pricing.effectivePrice,
                    paymentMode: pricing.paymentMode,
                    creditRequired: pricing.creditRequired,
                    currency: pricing.currency,
                    fallbackAmount: pricing.effectivePrice ?? 0,
                    tenantCurrency: currency,
                  ),
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
    // Already booked — show status based on payment
    if (userStatus.isBooked) {
      final status = userStatus.paymentStatus;
      final isPending = status == 'pending_payment' ||
          status == 'pending_confirmation';

      final label = switch (status) {
        'pending_payment' => 'Menunggu Pembayaran',
        'pending_confirmation' => 'Menunggu Konfirmasi',
        _ => 'Sudah Terdaftar',
      };

      final bgColor = isPending ? AppColors.warning : AppColors.success;
      final icon = isPending ? Icons.hourglass_top : Icons.check_circle;

      return FilledButton.icon(
        onPressed: null,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: bgColor.withValues(alpha: 0.8),
          disabledForegroundColor: Colors.white,
          minimumSize: const Size(160, AppDimensions.buttonHeightMd),
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

    // No credits and no bank info — can't transact
    if (userStatus.creditBalance < 1 && !tenantPayment.isComplete) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pembayaran belum tersedia untuk sesi ini',
              style: AppTypography.caption.copyWith(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.xs),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(160, AppDimensions.buttonHeightMd),
                ),
                child: const Text('Tidak Dapat Bergabung'),
              ),
            ),
          ],
        ),
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
    AppHaptics.tap();

    // ── Credit path: unchanged — call join API then go to confirmation ──
    if (userStatus.creditBalance >= 1) {
      final confirmed = await showCreditConfirmationSheet(
        context: context,
        creditBalance: userStatus.creditBalance,
      );
      if (confirmed != true || !context.mounted) return;

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

      context.go(
        AppRoutes.marketplaceSessionConfirmation(sessionId),
        extra: {
          'sessionName': session.safeTitle,
          'price': pricing.effectivePrice ?? 0,
        },
      );
      return;
    }

    // ── Paid path: navigate to checkout (P4b) ────────────────────────────
    final productId = pricing.productId;
    final tenantSlug = session.tenant?.slug;
    final amount = pricing.effectivePrice ?? 0;

    if (productId == null || tenantSlug == null || tenantSlug.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data produk tidak lengkap, coba lagi nanti')),
      );
      return;
    }

    context.push('/payment/checkout', extra: {
      'tenantSlug': tenantSlug,
      'productId': productId,
      'sessionId': int.parse(sessionId),
      'productLabel': session.safeTitle,
      'amount': amount,
      'sessionStartAt': session.startAt,
      'venueName': session.venue?.name,
    });
  }
}
