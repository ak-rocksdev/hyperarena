import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/club/data/models/student_detail.dart';
import 'package:hyperarena/shared/widgets/money_text.dart';
import 'package:hyperarena/shared/widgets/zoomable_avatar.dart';
import 'package:intl/intl.dart';

/// Teal hero band + outstanding banner that overlaps it.
///
/// Layout:
///   ┌────────────────────────────┐
///   │  ←  ⋮                       │  ← SafeArea top + back/more
///   │     ⭕ avatar               │
///   │     Name                    │
///   │     [age] [gender] [sport]  │
///   │     [Sejak X] [Level Y]     │
///   └────────────────────────────┘
///   ┌────────────────────────────┐  ← overlap (negative margin)
///   │ │ BELUM TERBAYAR  [Tagih]   │
///   │ │ Rp 450.000                │
///   │ │ 2 tagihan · tertua 14 hari│
///   │ │ ▓▓▓▓░░░░░░░░░             │  ← aging ramp (hidden if days null)
///   └────────────────────────────┘
class MemberHeroWithOutstanding extends ConsumerWidget {
  const MemberHeroWithOutstanding({
    super.key,
    required this.student,
    required this.financial,
  });

  final StudentProfileSummary student;
  final FinancialStats financial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasOutstanding = financial.outstandingAmount > 0;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _HeroBand(student: student, hasOutstandingFooterRoom: hasOutstanding),
        if (hasOutstanding)
          Positioned(
            left: AppDimensions.screenHorizontal,
            right: AppDimensions.screenHorizontal,
            bottom: -28,
            child: _OutstandingBanner(financial: financial),
          ),
      ],
    );
  }
}

class _HeroBand extends StatelessWidget {
  const _HeroBand({
    required this.student,
    required this.hasOutstandingFooterRoom,
  });

  final StudentProfileSummary student;

  /// When the banner overlaps below, leave room so the chips don't collide.
  final bool hasOutstandingFooterRoom;

  String _greetingForSince(StudentDetailEnrollment? enrollment) {
    final d = enrollment?.enrolledAt;
    if (d == null) return '';
    return 'Sejak ${DateFormat('MMM yyyy', 'id').format(d)}';
  }

  String _genderLabel(String? g) =>
      switch (g) { 'male' => 'Pria', 'female' => 'Wanita', _ => g ?? '' };

  @override
  Widget build(BuildContext context) {
    final since = _greetingForSince(student.enrollment);
    final levelName = student.enrollment?.levelName;
    final age = student.age != null ? '${student.age} thn' : null;
    final gender = _genderLabel(student.gender);
    final sport = student.sport;

    final inlineMeta = [
      ?age,
      if (gender.isNotEmpty) gender,
      if (sport != null && sport.isNotEmpty) sport,
    ].join(' · ');

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [
            Color(0xFF1F7A74),
            Color(0xFF155956),
          ],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: hasOutstandingFooterRoom
                ? AppDimensions.xxl + 14
                : AppDimensions.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TopBar(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ZoomableAvatar(
                      heroTag: 'member-${student.id}',
                      imageUrl:
                          student.photoUrls?['lg'] ?? student.photoUrls?['md'],
                      fallbackInitials: Formatters.initials(student.fullName),
                      radius: 32,
                      bgColor: Colors.white,
                      fgColor: const Color(0xFF155956),
                      ringColor: Colors.white.withValues(alpha: 0.32),
                      caption: student.fullName,
                    ),
                    const SizedBox(width: AppDimensions.base),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            student.fullName,
                            style: AppTypography.headingSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (inlineMeta.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              inlineMeta,
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (since.isNotEmpty || levelName != null) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: [
                                if (since.isNotEmpty)
                                  _PillChip(label: since),
                                if (levelName != null)
                                  _PillChip(label: 'Level $levelName'),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            tooltip: 'Kembali',
          ),
          const Spacer(),
          IconButton(
            onPressed: null,
            icon: Icon(
              Icons.more_vert,
              color: Colors.white.withValues(alpha: 0.85),
            ),
            tooltip: 'Lainnya',
          ),
        ],
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  const _PillChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _OutstandingBanner extends ConsumerWidget {
  const _OutstandingBanner({required this.financial});

  final FinancialStats financial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(tenantCurrencyProvider);
    final oldestDays = financial.oldestUnpaidDays;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: const Color(0xFFFCA5A5)),
          boxShadow: AppShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: AppColors.error),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.base),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'BELUM TERBAYAR',
                                  style: AppTypography.overline.copyWith(
                                    color: AppColors.errorDark,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                MoneyText(
                                  Formatters.formatCurrency(
                                      financial.outstandingAmount, currency),
                                  style: AppTypography.headingMedium.copyWith(
                                    color: AppColors.errorDark,
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: const [
                                      FontFeature.tabularFigures(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _countAndAgeText(financial, oldestDays),
                                  style: AppTypography.labelMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fitur tagih akan datang'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.send, size: 13),
                            label: const Text('Tagih'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              textStyle: AppTypography.labelMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusMd,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.md),
                      _AgingProgressBar(days: oldestDays),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _countAndAgeText(FinancialStats f, int? days) {
    final parts = <String>[
      '${f.outstandingCount} tagihan',
      if (days != null) 'tertua $days hari',
    ];
    return parts.join(' · ');
  }
}

class _AgingProgressBar extends StatelessWidget {
  const _AgingProgressBar({required this.days});

  /// Null when BE has not yet returned `oldest_unpaid_days` — bar still
  /// renders (empty track) for visual consistency.
  final int? days;

  /// Aging escalation thresholds — visual ramp:
  /// - 0–7 days  → muted (low signal)
  /// - 7–14 days → medium
  /// - 14–30 days → strong
  /// - > 30 days → escalate (full red)
  static const _maxDays = 30;

  @override
  Widget build(BuildContext context) {
    final ratio = days != null ? (days! / _maxDays).clamp(0.0, 1.0) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 4,
            backgroundColor: AppColors.neutral100,
            valueColor: AlwaysStoppedAnimation<Color>(
              days != null ? AppColors.error : AppColors.neutral300,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              days != null ? '14 hari (medium)' : 'Aging belum tersedia',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (days != null)
              Text(
                '30 hari → escalate',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
