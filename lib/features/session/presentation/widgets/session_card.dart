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
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';
import 'package:hyperarena/shared/widgets/session_hero.dart';

class SessionCard extends ConsumerWidget {
  final OpenSession session;

  const SessionCard({super.key, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sportColor = sportTheme.color(session.sport);
    final currency = ref.watch(tenantCurrencyProvider);
    final isFull = session.currentPlayers >= session.maxPlayers;
    final playerProgress =
        session.currentPlayers / session.maxPlayers;

    return Container(
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 16:9 hero — falls back to tenant logo when session has no
          // photo. Listing card uses md (640×360) per BE size guidance.
          SessionHero(
            photoUrls: session.photoUrls,
            photoPath: session.photoPath,
            size: SessionHeroSize.md,
            borderRadius: 0,
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                // Sport-colored accent bar
                Container(width: 4, color: sportColor),
                // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.base),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + sport badge
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            session.safeTitle,
                            style: AppTypography.titleSmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    // Host
                    Text(
                      'oleh ${session.hostName}',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    // Venue + date/time
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 14, color: AppColors.neutral400),
                        const SizedBox(width: AppDimensions.xxs),
                        Expanded(
                          child: Text(
                            session.venueName,
                            style: AppTypography.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.xxs),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: AppColors.neutral400),
                        const SizedBox(width: AppDimensions.xxs),
                        Text(
                          '${Formatters.formatDateShort(session.date)} '
                          '${Formatters.formatTimeRange(session.startTime, session.endTime)}',
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    // Player count with mini progress bar
                    Row(
                      children: [
                        Icon(Icons.people, size: 14, color: AppColors.neutral400),
                        const SizedBox(width: AppDimensions.xxs),
                        Text(
                          '${session.currentPlayers}/${session.maxPlayers} pemain',
                          style: AppTypography.labelMedium.copyWith(
                            color: isFull
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppDimensions.sm),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: playerProgress.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isFull
                                        ? AppColors.error
                                        : sportColor,
                                    borderRadius: BorderRadius.circular(
                                        AppDimensions.radiusFull),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    // Level range + price + action
                    Row(
                      children: [
                        if (session.minLevel != null || session.maxLevel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.neutral100,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusFull),
                            ),
                            child: Text(
                              _levelRange(),
                              style: AppTypography.badge,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          Formatters.formatCurrency(session.pricePerPerson, currency),
                          style: AppTypography.priceSmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.sm),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: isFull
                              ? AppColors.neutral300
                              : AppColors.secondary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.neutral200,
                          disabledForegroundColor: AppColors.neutral400,
                        ),
                        onPressed: isFull
                            ? null
                            : () => context.push(AppRoutes.session(session.id)),
                        child: Text(isFull ? 'Penuh' : 'Gabung'),
                      ),
                    ),
                  ],
                ),
              ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _levelRange() {
    final min = session.minLevel;
    final max = session.maxLevel;
    if (min != null && max != null) {
      return '${GamificationHelpers.tierLabel(min)} \u2013 ${GamificationHelpers.tierLabel(max)}';
    }
    if (min != null) return '${GamificationHelpers.tierLabel(min)}+';
    if (max != null) return 'Max ${GamificationHelpers.tierLabel(max)}';
    return 'Semua Level';
  }
}
