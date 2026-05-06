import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';

/// Club identity hero — logo (or initial monogram fallback) + name + sport.
/// Logo is tappable for full-screen zoom (shared `Hero` tag with the
/// fallback rendered identically at scale).
class ClubHero extends StatelessWidget {
  final String name;
  final String? logoUrl;
  final String? sport;
  final String? subtitle;

  const ClubHero({
    super.key,
    required this.name,
    this.logoUrl,
    this.sport,
    this.subtitle,
  });

  static const _heroTag = 'club-logo';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0F172A), // slate-900 — deep, clubhouse feel
            Color(0xFF1E3A8A), // primary900
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.lg,
        AppDimensions.screenHorizontal,
        AppDimensions.lg,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ZoomableAvatar(
              heroTag: _heroTag,
              imageUrl: logoUrl,
              fallbackInitials: Formatters.initials(name),
              radius: 36,
              bgColor: Colors.white.withValues(alpha: 0.12),
              fgColor: Colors.white,
              caption: name,
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'KLUB SAYA',
                    style: AppTypography.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    name,
                    style: AppTypography.headingMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (sport != null || subtitle != null) ...[
                    const SizedBox(height: AppDimensions.xs),
                    Wrap(
                      spacing: AppDimensions.xs,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (sport != null)
                          _MetaChip(
                            label: sport!,
                            icon: Icons.sports_tennis,
                          ),
                        if (subtitle != null)
                          _MetaChip(
                            label: subtitle!,
                            icon: Icons.location_on_outlined,
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: Colors.white.withValues(alpha: 0.85)),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

/// 4-column vital-stats ticker that sits under [ClubHero]. Numbers count up
/// on first build for a small "dashboard tickle" cue. Layout adapts: 2x2
/// grid on narrow screens (<360dp), single row otherwise.
class ClubStatsStrip extends StatelessWidget {
  final int activeMembers;
  final int activeCoaches;
  final int sessionsThisMonth;
  final int outstandingTotal;
  final int outstandingCount;

  const ClubStatsStrip({
    super.key,
    required this.activeMembers,
    required this.activeCoaches,
    required this.sessionsThisMonth,
    required this.outstandingTotal,
    required this.outstandingCount,
  });

  @override
  Widget build(BuildContext context) {
    final hasOutstanding = outstandingTotal > 0;
    final stats = [
      _ClubStat(
        label: 'ANGGOTA',
        value: activeMembers,
        formatter: (v) => v.toString(),
        color: AppColors.primary900,
        hint: 'aktif 30 hari',
      ),
      _ClubStat(
        label: 'COACH',
        value: activeCoaches,
        formatter: (v) => v.toString(),
        color: AppColors.primary900,
        hint: 'mengasuh sesi',
      ),
      _ClubStat(
        label: 'SESI / BULAN',
        value: sessionsThisMonth,
        formatter: (v) => v.toString(),
        color: AppColors.primary900,
        hint: 'bulan berjalan',
      ),
      _ClubStat(
        label: 'TAGIHAN',
        value: outstandingTotal,
        formatter: (v) =>
            v == 0 ? '—' : Formatters.formatRupiahCompact(v),
        color: hasOutstanding ? AppColors.error : AppColors.success,
        hint: hasOutstanding
            ? '$outstandingCount anggota'
            : 'semua lunas',
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final isNarrow = constraints.maxWidth < 360;
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenHorizontal,
        ).copyWith(top: AppDimensions.md),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.md,
          vertical: AppDimensions.lg,
        ),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: isNarrow
            ? Column(
                children: [
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: _buildTile(stats[0])),
                        const _StatDivider(),
                        Expanded(child: _buildTile(stats[1])),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.md),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: _buildTile(stats[2])),
                        const _StatDivider(),
                        Expanded(child: _buildTile(stats[3])),
                      ],
                    ),
                  ),
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  children: [
                    for (var i = 0; i < stats.length; i++) ...[
                      Expanded(child: _buildTile(stats[i])),
                      if (i < stats.length - 1) const _StatDivider(),
                    ],
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildTile(_ClubStat stat) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, t, _) {
        final animatedValue = (stat.value * t).round();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              stat.label,
              style: AppTypography.caption.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              stat.formatter(animatedValue),
              style: AppTypography.headingMedium.copyWith(
                color: stat.color,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              stat.hint,
              style: AppTypography.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }
}

class _ClubStat {
  final String label;
  final int value;
  final String Function(int) formatter;
  final Color color;
  final String hint;

  const _ClubStat({
    required this.label,
    required this.value,
    required this.formatter,
    required this.color,
    required this.hint,
  });
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      color: AppColors.neutral100,
      margin: const EdgeInsets.symmetric(vertical: 4),
    );
  }
}
