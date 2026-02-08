import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/organizer/data/models/club_member.dart';
import 'package:hyperarena/features/organizer/data/models/club_profile.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:intl/intl.dart';

class OrganizerCommunityScreen extends ConsumerWidget {
  const OrganizerCommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(clubProfileProvider);
    final membersAsync = ref.watch(clubMembersProvider);
    final sessionsAsync = ref.watch(organizerSessionsProvider);

    return Scaffold(
      backgroundColor: AppSurfaces.background,
      body: AsyncValueWidget(
        value: profileAsync,
        data: (profile) => AsyncValueWidget(
          value: membersAsync,
          data: (members) {
            final sessionsThisMonth = sessionsAsync.whenOrNull(
                  data: (sessions) {
                    final now = DateTime.now();
                    return sessions
                        .where(
                          (s) =>
                              s.date.month == now.month &&
                              s.date.year == now.year,
                        )
                        .length;
                  },
                ) ??
                0;
            final activeSports = sessionsAsync.whenOrNull(
                  data: (sessions) =>
                      sessions.map((s) => s.sport).toSet().length,
                ) ??
                0;

            // Sort: role priority (admin → captain → member), then sessions desc
            final sortedMembers = [...members]..sort((a, b) {
              final rolePriority = {
                ClubMemberRole.admin: 0,
                ClubMemberRole.captain: 1,
                ClubMemberRole.member: 2,
              };
              final roleCompare =
                  rolePriority[a.role]!.compareTo(rolePriority[b.role]!);
              if (roleCompare != 0) return roleCompare;
              return b.sessionsPlayed.compareTo(a.sessionsPlayed);
            });

            if (members.isEmpty) {
              return Column(
                children: [
                  _ClubHeroHeader(profile: profile),
                  const Expanded(
                    child: EmptyState(
                      message: 'Belum ada anggota',
                      icon: Icons.group_off_outlined,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    child: _InviteButton(),
                  ),
                  const SizedBox(height: AppDimensions.screenBottom),
                ],
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(clubProfileProvider);
                ref.invalidate(clubMembersProvider);
                ref.invalidate(organizerSessionsProvider);
              },
              edgeOffset: 0,
              child: CustomScrollView(
                slivers: [
                  // ── Cover Photo + Glass Identity ───────────
                  SliverToBoxAdapter(
                    child: _ClubHeroHeader(profile: profile),
                  ),

                  // ── Body ───────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.screenHorizontal,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: AppDimensions.lg),

                        // ── Stats Strip ──────────────────────
                        _StatsStrip(
                          memberCount: members.length,
                          sessionsThisMonth: sessionsThisMonth,
                          activeSports: activeSports,
                        ),
                        const SizedBox(height: AppDimensions.lg),

                        // ── Invite CTA (above member list) ───
                        _InviteButton(),
                        const SizedBox(height: AppDimensions.lg),

                        // ── Section Header ───────────────────
                        Row(
                          children: [
                            Text(
                              'Anggota',
                              style: AppTypography.titleMedium,
                            ),
                            const SizedBox(width: AppDimensions.sm),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.sm,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary50,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull,
                                ),
                              ),
                              child: Text(
                                '${members.length}',
                                style: AppTypography.labelMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.md),

                        // ── Member Cards ─────────────────────
                        Container(
                          decoration: BoxDecoration(
                            color: AppSurfaces.surface,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg,
                            ),
                            boxShadow: AppShadows.sm,
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              for (var i = 0;
                                  i < sortedMembers.length;
                                  i++) ...[
                                _MemberRow(
                                  member: sortedMembers[i],
                                  allMembers: sortedMembers,
                                ),
                                if (i < sortedMembers.length - 1)
                                  Divider(
                                    height: 1,
                                    indent: AppDimensions.base +
                                        44 +
                                        AppDimensions.md,
                                    endIndent: AppDimensions.base,
                                    color: AppColors.border,
                                  ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppDimensions.screenBottom),
                      ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Cover Photo Hero + Glassmorphism Identity ───────────────────────────
class _ClubHeroHeader extends StatelessWidget {
  const _ClubHeroHeader({required this.profile});

  final ClubProfile profile;

  @override
  Widget build(BuildContext context) {
    final sinceLabel = DateFormat('MMMM yyyy', 'id').format(profile.createdAt);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── Cover photo + gradient overlay ────────────────
        SizedBox(
          height: 200,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Cover image
              if (profile.coverPhotoUrl != null)
                Image.network(
                  profile.coverPhotoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _coverPlaceholder(),
                )
              else
                _coverPlaceholder(),

              // Gradient overlay for readability
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xCC1D4ED8),
                    ],
                    stops: [0.2, 1.0],
                  ),
                ),
              ),

              // Safe area + edit button
              SafeArea(
                bottom: false,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.md),
                    child: _GlassButton(
                      icon: Icons.edit_outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profil klub segera hadir'),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Glass identity card (overlapping the cover) ──
        Positioned(
          left: AppDimensions.screenHorizontal,
          right: AppDimensions.screenHorizontal,
          bottom: -60,
          child: _GlassIdentityCard(
            profile: profile,
            sinceLabel: sinceLabel,
          ),
        ),

        // Invisible spacer so Stack sizes correctly
        // (cover 200 + overlap 60 + card extends ~80 below)
        const SizedBox(height: 200 + 80),
      ],
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppSurfaces.primaryGradient,
      ),
      child: Center(
        child: Icon(
          Icons.sports_tennis,
          size: 64,
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}

// ── Glassmorphism Identity Card ─────────────────────────────────────────
class _GlassIdentityCard extends StatelessWidget {
  const _GlassIdentityCard({
    required this.profile,
    required this.sinceLabel,
  });

  final ClubProfile profile;
  final String sinceLabel;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.base),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.50),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 8),
                blurRadius: 24,
                color: const Color(0xFF1D4ED8).withValues(alpha: 0.15),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Avatar ─────────────────────────
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppSurfaces.primaryGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                      color: AppColors.primary.withValues(alpha: 0.30),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    profile.name.substring(0, 1).toUpperCase(),
                    style: AppTypography.headingMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),

              // ── Info ───────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: AppTypography.titleMedium,
                    ),
                    if (profile.tagline != null &&
                        profile.tagline!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.tagline!,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: AppDimensions.sm),
                    Wrap(
                      spacing: AppDimensions.sm,
                      runSpacing: AppDimensions.xs,
                      children: [
                        if (profile.city != null && profile.city!.isNotEmpty)
                          _InfoChip(
                            icon: Icons.location_on_outlined,
                            label: profile.city!,
                          ),
                        _InfoChip(
                          icon: Icons.calendar_month_outlined,
                          label: 'Sejak $sinceLabel',
                        ),
                      ],
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

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.primary),
          const SizedBox(width: AppDimensions.xs),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.primary700,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Glassmorphism Button ────────────────────────────────────────────────
class _GlassButton extends StatelessWidget {
  const _GlassButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.white.withValues(alpha: 0.20),
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 36,
              height: 36,
              child: Icon(icon, size: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Stats Strip ─────────────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.memberCount,
    required this.sessionsThisMonth,
    required this.activeSports,
  });

  final int memberCount;
  final int sessionsThisMonth;
  final int activeSports;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          icon: Icons.group_outlined,
          value: '$memberCount',
          label: 'Anggota',
          color: AppColors.primary,
        ),
        const SizedBox(width: AppDimensions.sm),
        _StatCard(
          icon: Icons.event_outlined,
          value: '$sessionsThisMonth',
          label: 'Sesi Bulan Ini',
          color: AppColors.secondary,
        ),
        const SizedBox(width: AppDimensions.sm),
        _StatCard(
          icon: Icons.sports_tennis_outlined,
          value: '$activeSports',
          label: 'Sport Aktif',
          color: AppColors.accent,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.md,
          horizontal: AppDimensions.sm,
        ),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: AppDimensions.xs),
            Text(
              value,
              style: AppTypography.numberSmall.copyWith(color: color),
            ),
            Text(
              label,
              style: AppTypography.caption,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Helper functions ─────────────────────────────────────────────────────

Color _activityColor(DateTime? lastActive) {
  if (lastActive == null) return AppColors.neutral400;
  final diff = DateTime.now().difference(lastActive);
  if (diff.inHours < 24) return AppColors.success;
  if (diff.inDays < 7) return AppColors.warning;
  return AppColors.neutral400;
}

({String label, Color bg, Color text})? _roleBadgeConfig(ClubMemberRole role) {
  return switch (role) {
    ClubMemberRole.admin => (
      label: 'Admin',
      bg: AppColors.primary,
      text: AppColors.textOnPrimary,
    ),
    ClubMemberRole.captain => (
      label: 'Kapten',
      bg: AppColors.secondary,
      text: Colors.white,
    ),
    ClubMemberRole.member => null,
  };
}

List<(String, Color)> _autoTags(
  ClubMember member,
  List<ClubMember> allMembers,
) {
  final tags = <(String, Color)>[];

  // "Anggota Baru" if joined < 30 days ago
  final daysSinceJoin = DateTime.now().difference(member.joinedAt).inDays;
  if (daysSinceJoin < 30) {
    tags.add(('Anggota Baru', AppColors.secondary));
  }

  // "Paling Aktif" if top 2 by sessionsPlayed
  final sorted = [...allMembers]..sort(
      (a, b) => b.sessionsPlayed.compareTo(a.sessionsPlayed),
    );
  final top2Ids = sorted.take(2).map((m) => m.id).toSet();
  if (top2Ids.contains(member.id)) {
    tags.add(('Si Paling Aktif', AppColors.accent));
  }

  return tags;
}

// ── Member Row ──────────────────────────────────────────────────────────
class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member, required this.allMembers});

  final ClubMember member;
  final List<ClubMember> allMembers;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final gamifTheme =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    final roleBadge = _roleBadgeConfig(member.role);
    final tags = _autoTags(member, allMembers);
    final activityDotColor = _activityColor(member.lastActiveAt);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profil ${member.name} segera hadir')),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.base,
            vertical: AppDimensions.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar + Activity Dot ───────────────
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primary50,
                      backgroundImage: member.avatarUrl != null
                          ? NetworkImage(member.avatarUrl!)
                          : null,
                      child: member.avatarUrl == null
                          ? Text(
                              member.name.substring(0, 1).toUpperCase(),
                              style: AppTypography.titleSmall.copyWith(
                                color: AppColors.primary,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: activityDotColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.md),

              // ── Info Column ─────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Name + Role Badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            member.name,
                            style: AppTypography.titleSmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (roleBadge != null) ...[
                          const SizedBox(width: AppDimensions.sm),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: roleBadge.bg,
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              roleBadge.label,
                              style: AppTypography.caption.copyWith(
                                color: roleBadge.text,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Row 2: Tier chip + Auto-tags
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        // Level tier chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: gamifTheme.levelBackgroundColor(
                              member.levelTier,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            GamificationHelpers.tierLabel(member.levelTier),
                            style: AppTypography.caption.copyWith(
                              color: gamifTheme.levelTextColor(
                                member.levelTier,
                              ),
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Auto-tags
                        for (final (label, color) in tags)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              label,
                              style: AppTypography.caption.copyWith(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Row 3: Mini stat row (sessions + streak)
                    Row(
                      children: [
                        Icon(
                          Icons.sports_score,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${member.sessionsPlayed} sesi',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                        if (member.attendanceStreak > 0) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              '\u00B7',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          Text(
                            '\u{1F525}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${member.attendanceStreak} streak',
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),

                    // Row 4: Sport chips
                    if (member.sportPreferences.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: member.sportPreferences.map((sport) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: sportTheme.backgroundColor(sport),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusFull,
                              ),
                            ),
                            child: Text(
                              SportChipSelector.sportLabel(sport),
                              style: AppTypography.caption.copyWith(
                                color: sportTheme.textColor(sport),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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

// ── Invite Button ───────────────────────────────────────────────────────
class _InviteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppSurfaces.primaryGradient,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.colored,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur undangan akan segera hadir'),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.md,
              horizontal: AppDimensions.lg,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppDimensions.sm),
                Text(
                  'Undang Anggota',
                  style: AppTypography.button.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
