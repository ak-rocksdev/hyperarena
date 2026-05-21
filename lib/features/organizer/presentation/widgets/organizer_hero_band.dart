import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_dashboard_stats.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_earnings_summary.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/providers/money_visibility_provider.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';
import 'package:intl/intl.dart';

/// Teal gradient header band for the organizer dashboard.
///
/// Composes three blocks in a single brand-colored area:
///   1. App header — logo + club name + greeting + bell
///   2. Monthly revenue hero — uppercase label, big tabular amount,
///      delta chip, sessions caption
///   3. Glass split tiles — Belum tertagih / Saldo siap cair
///
/// Skeleton fallback when [stats]/[earnings]/[club] are still loading. The
/// band always renders so the layout doesn't jump in.
class OrganizerHeroBand extends ConsumerWidget {
  const OrganizerHeroBand({
    super.key,
    required this.stats,
    required this.earnings,
    required this.club,
  });

  final OrganizerDashboardStats? stats;
  final OrganizerEarningsSummary? earnings;
  final ClubProfile? club;

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'pagi';
    if (hour < 15) return 'siang';
    if (hour < 18) return 'sore';
    return 'malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final firstName = Formatters.firstName(user?.name, fallback: 'Organizer');
    final clubName = club?.name ?? 'HyperArena Club';

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.7, 1.0],
          colors: [
            Color(0xFF1F7A74), // brand
            Color(0xFF155956), // brand dark
            Color(0xFF0F4442), // brand deep
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppDimensions.lg),
          child: Column(
            children: [
              _HeaderRow(
                clubName: clubName,
                firstName: firstName,
                greeting: _greeting(),
              ),
              _RevenueHero(stats: stats),
              _GlassSplitTiles(stats: stats, earnings: earnings),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header row — logo + club + greeting + bell
// ─────────────────────────────────────────────────────────────
class _HeaderRow extends StatelessWidget {
  const _HeaderRow({
    required this.clubName,
    required this.firstName,
    required this.greeting,
  });

  final String clubName;
  final String firstName;
  final String greeting;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.xs,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(
              'assets/brand/hyperarena_logo.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  clubName,
                  style: AppTypography.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    height: 1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Halo, $firstName 👋',
                  style: AppTypography.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _CircleIconButton(
            icon: Icons.notifications_outlined,
            showDot: true,
            // Notifications screen route exists at AppRoutes.notifications;
            // tap is wired by parent if needed. Keep button visual-only here
            // to avoid pulling go_router into a presentational widget.
            onTap: null,
          ),
          const SizedBox(width: 8),
          _CircleIconButton(
            icon: Icons.person_outline,
            // Profile moved out of organizer bottom nav (PR 4d 5-tab).
            // This icon is the new entry point from the dashboard header.
            onTap: () => context.push(AppRoutes.organizerProfile),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    this.onTap,
    this.showDot = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    const size = 38.0;
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              if (showDot)
                Positioned(
                  top: size * 0.22,
                  right: size * 0.22,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF155956),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Revenue hero — small label, big number, delta + sessions caption
// ─────────────────────────────────────────────────────────────
class _RevenueHero extends ConsumerWidget {
  const _RevenueHero({required this.stats});

  final OrganizerDashboardStats? stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthName = DateFormat('MMMM', 'id').format(DateTime.now());
    final monthly = stats?.monthlyEarnings ?? 0;
    final lastMonth = stats?.lastMonthEarnings;
    final sessionsMonth = stats?.sessionsThisMonth;
    final currency = ref.watch(tenantCurrencyProvider);

    final delta = (lastMonth != null && lastMonth > 0)
        ? ((monthly - lastMonth) / lastMonth * 100)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.lg,
        AppDimensions.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'PENDAPATAN BULAN INI · ${monthName.toUpperCase()}',
                  style: AppTypography.overline.copyWith(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              const _MoneyEyeToggle(),
            ],
          ),
          const SizedBox(height: 4),
          MoneyText(
            Formatters.formatCurrency(monthly, currency),
            style: AppTypography.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              height: 1.05,
              letterSpacing: -1,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Always render caption row so the hero feels complete pre-BE
          // (delta chip + sessions count drop out individually when null).
          const SizedBox(height: AppDimensions.xs),
          _DeltaCaption(
            delta: delta,
            sessionsThisMonth: sessionsMonth,
          ),
        ],
      ),
    );
  }
}

class _DeltaCaption extends StatelessWidget {
  const _DeltaCaption({required this.delta, required this.sessionsThisMonth});

  final double? delta;
  final int? sessionsThisMonth;

  @override
  Widget build(BuildContext context) {
    final positive = (delta ?? 0) >= 0;
    final chipBg = positive
        ? const Color(0xFF22C55E).withValues(alpha: 0.25)
        : const Color(0xFFEF4444).withValues(alpha: 0.25);
    final chipFg = positive
        ? const Color(0xFF86EFAC)
        : const Color(0xFFFCA5A5);

    final captionStyle = AppTypography.bodySmall.copyWith(
      color: Colors.white.withValues(alpha: 0.85),
    );

    // Always render the row; delta chip drops out when null; sessions
    // caption shows "—" placeholder when null (rather than disappearing)
    // so the hero footer keeps a consistent height across loads.
    final sessionsText = sessionsThisMonth != null
        ? '$sessionsThisMonth sesi terselenggara'
        : '— sesi bulan ini';
    final separatorBeforeSessions = delta != null ? 'vs bulan lalu · ' : null;

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 4,
      children: [
        if (delta != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: chipBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  positive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 11,
                  color: chipFg,
                ),
                const SizedBox(width: 2),
                Text(
                  '${delta!.abs().toStringAsFixed(1).replaceAll('.', ',')}%',
                  style: AppTypography.labelMedium.copyWith(
                    color: chipFg,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        if (separatorBeforeSessions != null)
          Text(separatorBeforeSessions, style: captionStyle),
        Text(sessionsText, style: captionStyle),
      ],
    );
  }
}

class _MoneyEyeToggle extends ConsumerWidget {
  const _MoneyEyeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(moneyVisibilityProvider);
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => ref.read(moneyVisibilityProvider.notifier).toggle(),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(
            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white.withValues(alpha: 0.85),
            size: 15,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Glass split tiles — Belum tertagih / Saldo siap cair
// ─────────────────────────────────────────────────────────────
class _GlassSplitTiles extends ConsumerWidget {
  const _GlassSplitTiles({required this.stats, required this.earnings});

  final OrganizerDashboardStats? stats;
  final OrganizerEarningsSummary? earnings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final outstanding = stats?.totalUnpaidAmount ?? 0;
    final unpaidCount = stats?.unpaidMemberCount;
    final available = earnings?.availableBalance ?? 0;
    final pending = earnings?.pendingBalance ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        AppDimensions.md,
        AppDimensions.lg,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: _GlassTile(
              label: 'Belum tertagih',
              amount: Formatters.formatCurrencyCompact(outstanding, currency),
              // Placeholder when BE-pending `unpaidMemberCount` arrives.
              sub: unpaidCount != null ? '$unpaidCount anggota' : '— anggota',
              accent: const Color(0xFFFCD34D),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: _GlassTile(
              label: 'Saldo siap cair',
              amount: Formatters.formatCurrencyCompact(available, currency),
              sub: pending > 0
                  ? '+${Formatters.formatCurrencyCompact(pending, currency)} tertunda'
                  : 'tidak ada tertunda',
              accent: const Color(0xFF86EFAC),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  const _GlassTile({
    required this.label,
    required this.amount,
    required this.sub,
    required this.accent,
  });

  final String label;
  final String amount;
  final String? sub;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.overline.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          MoneyText(
            amount,
            style: AppTypography.headingSmall.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
            maskWidth: 3,
          ),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(
              sub!,
              style: AppTypography.labelMedium.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
