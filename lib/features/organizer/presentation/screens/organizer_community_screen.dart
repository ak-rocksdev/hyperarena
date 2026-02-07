import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
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
      body: SafeArea(
        child: AsyncValueWidget(
          value: profileAsync,
          data: (profile) => AsyncValueWidget(
            value: membersAsync,
            data: (members) {
              // Compute stats
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

              if (members.isEmpty) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(
                        AppDimensions.screenHorizontal,
                      ),
                      child: _ClubIdentityCard(profile: profile),
                    ),
                    const Expanded(
                      child: EmptyState(
                        message: 'Belum ada anggota',
                        icon: Icons.group_off_outlined,
                      ),
                    ),
                    _InviteButton(),
                    const SizedBox(height: AppDimensions.screenBottom),
                  ],
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(clubProfileProvider);
                        ref.invalidate(clubMembersProvider);
                        ref.invalidate(organizerSessionsProvider);
                      },
                      child: ListView(
                        padding: const EdgeInsets.all(
                          AppDimensions.screenHorizontal,
                        ),
                        children: [
                          // ── Identity Card ──────────────────────
                          _ClubIdentityCard(profile: profile),
                          const SizedBox(height: AppDimensions.base),

                          // ── Stats Strip ────────────────────────
                          _StatsStrip(
                            memberCount: members.length,
                            sessionsThisMonth: sessionsThisMonth,
                            activeSports: activeSports,
                          ),
                          const SizedBox(height: AppDimensions.lg),

                          // ── Member List Header ─────────────────
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
                                  style: AppTypography.caption.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.sm),

                          // ── Member Rows ────────────────────────
                          ...members.map(
                            (member) => _MemberRow(member: member),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Invite CTA ───────────────────────────
                  _InviteButton(),
                  const SizedBox(height: AppDimensions.screenBottom),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Club Identity Card ─────────────────────────────────────────────────
class _ClubIdentityCard extends StatelessWidget {
  const _ClubIdentityCard({required this.profile});

  final ClubProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primary50,
                child: Text(
                  profile.name.substring(0, 1).toUpperCase(),
                  style: AppTypography.headingSmall.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: AppTypography.headingSmall,
                    ),
                    if (profile.tagline != null &&
                        profile.tagline!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        profile.tagline!,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (profile.city != null &&
                        profile.city!.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.neutral400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile.city!,
                            style: AppTypography.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 32,
              height: 32,
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 18,
                icon: Icon(
                  Icons.edit_outlined,
                  color: AppColors.neutral400,
                ),
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
        ],
      ),
    );
  }
}

// ── Stats Strip ────────────────────────────────────────────────────────
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
        Expanded(
          child: _StatCard(
            icon: Icons.group_outlined,
            value: '$memberCount',
            label: 'Anggota',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.event_outlined,
            value: '$sessionsThisMonth',
            label: 'Sesi Bulan Ini',
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _StatCard(
            icon: Icons.sports_tennis_outlined,
            value: '$activeSports',
            label: 'Sport Aktif',
          ),
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
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: AppColors.neutral400),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.headingSmall.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Member Row ─────────────────────────────────────────────────────────
class _MemberRow extends StatelessWidget {
  const _MemberRow({required this.member});

  final ClubMember member;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final joinLabel =
        'Bergabung ${DateFormat('d MMM yyyy', 'id').format(member.joinedAt)}';

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.md),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: AppShadows.xs,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary50,
              child: Text(
                member.name.substring(0, 1).toUpperCase(),
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.name, style: AppTypography.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    joinLabel,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
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
            IconButton(
              icon: Icon(
                Icons.message_outlined,
                color: AppColors.neutral400,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur pesan akan segera hadir'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Invite Button ──────────────────────────────────────────────────────
class _InviteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur undangan akan segera hadir'),
              ),
            );
          },
          icon: const Icon(Icons.person_add_outlined),
          label: const Text('Undang Anggota'),
        ),
      ),
    );
  }
}
