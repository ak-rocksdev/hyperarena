import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/core/mocks/mock_venues.dart';
import 'package:hyperarena/features/review/presentation/widgets/post_session_review_banner.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart'
    show OpenSessionStatus;
import 'package:hyperarena/features/session/providers/session_join_provider.dart';
import 'package:hyperarena/features/session/providers/session_providers.dart';
import 'package:hyperarena/shared/widgets/venue_location_section.dart';

class SessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const SessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionListProvider);
    final joinState = ref.watch(sessionJoinProvider);
    final currency = ref.watch(tenantCurrencyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Sesi')),
      body: AsyncValueWidget(
        value: sessionAsync,
        loading: () => ShimmerLoading.card(),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(sessionListProvider),
        ),
        data: (sessions) {
          final session = sessions.firstWhere(
            (s) => s.id == sessionId,
            orElse: () => sessions.first,
          );

          final venue = MockVenues.venues
              .where((v) => v.id == session.venueId)
              .firstOrNull;

          // Initialize join state if needed
          if (joinState.session?.id != session.id) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ref.read(sessionJoinProvider.notifier).setSession(session);
            });
          }

          final sportTheme =
              Theme.of(context).extension<SportThemeExtension>()!;
          final isFull = session.currentPlayers >= session.maxPlayers;
          final emptySlots = session.maxPlayers - session.currentPlayers;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.all(AppDimensions.screenHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sport badge + title
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: sportTheme.backgroundColor(session.sport),
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull),
                        ),
                        child: Text(
                          SportChipSelector.sportLabel(session.sport),
                          style: AppTypography.labelMedium.copyWith(
                            color: sportTheme.textColor(session.sport),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.sm),
                      Text(session.title, style: AppTypography.headingLarge),
                      const SizedBox(height: AppDimensions.xs),
                      Text(
                        'oleh ${session.hostName}',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      // Info card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.base),
                        decoration: BoxDecoration(
                          color: AppSurfaces.surface,
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg),
                          boxShadow: AppShadows.sm,
                        ),
                        child: Column(
                          children: [
                            _InfoRow(
                              icon: Icons.location_on,
                              label: session.venueName,
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _InfoRow(
                              icon: Icons.calendar_today,
                              label: Formatters.formatDate(session.date),
                            ),
                            const SizedBox(height: AppDimensions.sm),
                            _InfoRow(
                              icon: Icons.access_time,
                              label: Formatters.formatTimeRange(
                                  session.startTime, session.endTime),
                            ),
                            if (session.minLevel != null ||
                                session.maxLevel != null) ...[
                              const SizedBox(height: AppDimensions.sm),
                              _InfoRow(
                                icon: Icons.trending_up,
                                label: _levelRange(
                                    session.minLevel, session.maxLevel),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.xl),

                      // Description
                      if (session.description != null) ...[
                        Text('Deskripsi', style: AppTypography.titleMedium),
                        const SizedBox(height: AppDimensions.sm),
                        Text(session.description!,
                            style: AppTypography.bodyMedium),
                        const SizedBox(height: AppDimensions.xl),
                      ],

                      // Venue location map
                      VenueLocationSection(
                        venueName: session.venueName,
                        address: venue?.address,
                        lat: venue?.latitude,
                        lng: venue?.longitude,
                      ),

                      // Review banner (completed sessions with host).
                      // OLD mock screen — no server-side can_review flag, so
                      // banner renders the disabled state with no note.
                      if (session.status == OpenSessionStatus.completed)
                        PostSessionReviewBanner(
                          sessionId: session.id,
                          coachId: session.hostId,
                          coachName: session.hostName,
                          sessionTitle: session.title,
                          blockedReason: 'session_not_ended',
                        ),

                      // Participants section
                      Text('Peserta', style: AppTypography.titleMedium),
                      const SizedBox(height: AppDimensions.sm),
                      Text(
                        '${session.currentPlayers}/${session.maxPlayers} pemain',
                        style: AppTypography.caption,
                      ),
                      const SizedBox(height: AppDimensions.md),

                      // Avatar grid: filled + empty slots
                      Wrap(
                        spacing: AppDimensions.md,
                        runSpacing: AppDimensions.md,
                        children: [
                          // Filled participant avatars
                          ...session.participantNames.map((name) =>
                              _ParticipantAvatar(
                                name: name,
                                isHost: name == session.hostName,
                              )),
                          // Empty slots
                          ...List.generate(emptySlots, (i) {
                            final isSelected =
                                joinState.selectedSlotIndex == i;
                            return _EmptySlot(
                              index: i + 1,
                              isSelected: isSelected,
                              onTap: isFull
                                  ? null
                                  : () => ref
                                      .read(sessionJoinProvider.notifier)
                                      .selectSlot(i),
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.xxl),
                    ],
                  ),
                ),
              ),

              // Bottom bar: price + button
              Container(
                padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
                decoration: BoxDecoration(
                  color: AppSurfaces.surface,
                  boxShadow: AppShadows.bottomNav,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Biaya per orang',
                            style: AppTypography.caption),
                        Text(
                          Formatters.formatCurrency(session.pricePerPerson, currency),
                          style: AppTypography.priceLarge,
                        ),
                      ],
                    ),
                    const SizedBox(width: AppDimensions.base),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              AppDimensions.radiusSm),
                          boxShadow: (isFull || !joinState.hasSelectedSlot)
                              ? null
                              : AppShadows.colored,
                        ),
                        child: AppButton(
                          label: isFull
                              ? 'Sesi Penuh'
                              : !joinState.hasSelectedSlot
                                  ? 'Pilih Slot'
                                  : 'Gabung Sekarang',
                          isLarge: true,
                          onPressed:
                              (isFull || !joinState.hasSelectedSlot)
                                  ? null
                                  : () => context
                                      .push(AppRoutes.sessionFlowPayment),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _levelRange(dynamic min, dynamic max) {
    if (min != null && max != null) {
      return '${GamificationHelpers.tierLabel(min)} \u2013 ${GamificationHelpers.tierLabel(max)}';
    }
    if (min != null) return '${GamificationHelpers.tierLabel(min)}+';
    if (max != null) return 'Max ${GamificationHelpers.tierLabel(max)}';
    return 'Semua Level';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.neutral400),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: Text(label, style: AppTypography.bodyMedium),
        ),
      ],
    );
  }
}

class _ParticipantAvatar extends StatelessWidget {
  final String name;
  final bool isHost;

  const _ParticipantAvatar({required this.name, this.isHost = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary50,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: AppTypography.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            if (isHost)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.star, size: 8, color: Colors.white),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimensions.xs),
        SizedBox(
          width: 56,
          child: Text(
            name.split(' ').first,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _EmptySlot extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback? onTap;

  const _EmptySlot({
    required this.index,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary50 : Colors.transparent,
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.neutral300,
                width: isSelected ? 2.5 : 1.5,
                strokeAlign: BorderSide.strokeAlignInside,
              ),
            ),
            child: Icon(
              isSelected ? Icons.check : Icons.person_add_outlined,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.neutral400,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          SizedBox(
            width: 56,
            child: Text(
              isSelected ? 'Kamu' : 'Kosong',
              style: AppTypography.caption.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
