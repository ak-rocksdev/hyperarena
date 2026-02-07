import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/data/models/organizer_action_item.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/organizer_session_card.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(organizerDashboardProvider);
    final inboxAsync = ref.watch(organizerActionInboxProvider);
    final agendaAsync = ref.watch(organizerAgendaProvider);
    final earningsAsync = ref.watch(organizerEarningsProvider);

    Future<void> refreshAll() async {
      ref.invalidate(organizerDashboardProvider);
      ref.invalidate(organizerActionInboxProvider);
      ref.invalidate(organizerAgendaProvider);
      ref.invalidate(organizerEarningsProvider);
      await Future.wait([
        ref.read(organizerDashboardProvider.future),
        ref.read(organizerActionInboxProvider.future),
        ref.read(organizerAgendaProvider.future),
        ref.read(organizerEarningsProvider.future),
      ]);
    }

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Greeting Header ───────────────────────────────
                Text(
                  '${_greeting()}, Sari!',
                  style: AppTypography.headingLarge,
                ),
                AsyncValueWidget(
                  value: statsAsync,
                  data: (stats) => Text(
                    '${stats.sessionsNext7Days} sesi minggu ini',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 2. Attention Items (conditional) ─────────────────
                AsyncValueWidget(
                  value: inboxAsync,
                  data: (items) {
                    if (items.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perlu Perhatian',
                          style: AppTypography.titleMedium,
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        Container(
                          decoration: BoxDecoration(
                            color: AppSurfaces.surface,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusLg,
                            ),
                            boxShadow: AppShadows.sm,
                          ),
                          child: Column(
                            children: _buildActionItems(items, context),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xl),
                      ],
                    );
                  },
                ),

                // ── 3. Next Sessions Timeline ────────────────────────
                Row(
                  children: [
                    Text(
                      'Sesi Mendatang',
                      style: AppTypography.titleMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () =>
                          context.go(AppRoutes.organizerSessions),
                      child: const Text('Lihat Semua'),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.sm),
                AsyncValueWidget(
                  value: agendaAsync,
                  data: (sessions) {
                    if (sessions.isEmpty) {
                      return const EmptyState(
                        message: 'Belum ada sesi minggu ini',
                        icon: Icons.event_available_outlined,
                      );
                    }
                    final limited = sessions.take(5).toList();
                    return Column(
                      children: [
                        for (var i = 0; i < limited.length; i++) ...[
                          OrganizerSessionCard(session: limited[i]),
                          if (i < limited.length - 1)
                            const SizedBox(height: AppDimensions.sm),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 4. Create Session CTA ────────────────────────────
                GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.organizerCreateSession),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimensions.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, Color(0xFFEA580C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      boxShadow: AppShadows.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buat Sesi Baru',
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.xs),
                        Text(
                          'Atur jadwal dan undang pemain',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: AppDimensions.sm),
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // ── 5. Earnings Snapshot ─────────────────────────────
                AsyncValueWidget(
                  value: earningsAsync,
                  data: (earnings) => Container(
                    padding: const EdgeInsets.all(AppDimensions.base),
                    decoration: BoxDecoration(
                      color: AppSurfaces.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusLg,
                      ),
                      boxShadow: AppShadows.sm,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tersedia', style: AppTypography.caption),
                            Text(
                              Formatters.formatRupiah(
                                earnings.availableBalance,
                              ),
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tertunda', style: AppTypography.caption),
                            Text(
                              Formatters.formatRupiah(
                                earnings.pendingBalance,
                              ),
                              style: AppTypography.titleMedium.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () =>
                              context.push(AppRoutes.organizerEarnings),
                          child: const Text('Detail'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.huge),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionItems(
    List<OrganizerActionItem> items,
    BuildContext context,
  ) {
    final limited = items.take(5).toList();
    final widgets = <Widget>[];
    for (var i = 0; i < limited.length; i++) {
      widgets.add(_ActionItemRow(item: limited[i]));
      if (i < limited.length - 1) {
        widgets.add(
          const Divider(color: AppColors.neutral100, height: 1),
        );
      }
    }
    return widgets;
  }
}

class _ActionItemRow extends StatelessWidget {
  const _ActionItemRow({required this.item});

  final OrganizerActionItem item;

  Color get _severityColor => switch (item.severity) {
        OrganizerActionSeverity.high => AppColors.error,
        OrganizerActionSeverity.medium => AppColors.warning,
        OrganizerActionSeverity.low => AppColors.info,
      };

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.sessionId == null
          ? null
          : () => context.push(
                AppRoutes.organizerSessionDetail(item.sessionId!),
              ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.base,
          vertical: AppDimensions.sm,
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _severityColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTypography.titleSmall),
                  Text(
                    item.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.neutral400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
