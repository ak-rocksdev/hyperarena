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
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/organizer/providers/participant_management_provider.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OrganizerSessionDetailScreen extends ConsumerWidget {
  const OrganizerSessionDetailScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(organizerSessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Sesi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              return;
            }
            context.go(AppRoutes.organizerSessions);
          },
        ),
      ),
      body: AsyncValueWidget(
        value: sessionAsync,
        data: (session) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            children: [
              // 1. Session header card
              _SessionHeaderCard(session: session),
              const SizedBox(height: AppDimensions.lg),

              // 2. Health summary strip
              _HealthSummaryStrip(session: session),
              const SizedBox(height: AppDimensions.lg),

              // 3. Action buttons row
              _ActionButtonsRow(
                sessionId: sessionId,
                actions: ref.read(participantManagementProvider),
              ),
              const SizedBox(height: AppDimensions.lg),

              // 4. Participant roster
              _ParticipantRoster(sessionId: sessionId),
              const SizedBox(height: AppDimensions.lg),

              // 5. Settlement section
              _SettlementSection(sessionId: sessionId),
              const SizedBox(height: AppDimensions.huge),
            ],
          );
        },
      ),
    );
  }
}

// ── 1. Session Header Card ──────────────────────────────────────────────────

class _SessionHeaderCard extends StatelessWidget {
  const _SessionHeaderCard({required this.session});

  final OpenSession session;

  @override
  Widget build(BuildContext context) {
    final sportTheme = Theme.of(context).extension<SportThemeExtension>()!;
    final sportColor = sportTheme.color(session.sport);
    final sportBg = sportTheme.backgroundColor(session.sport);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: sport badge + edit icon
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: sportBg,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Text(
                  SportChipSelector.sportLabel(session.sport),
                  style: AppTypography.labelSmall.copyWith(color: sportColor),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Edit akan segera hadir'),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),

          // Title
          Text(session.title, style: AppTypography.headingSmall),
          const SizedBox(height: AppDimensions.sm),

          // Status pill
          _SessionStatusPill(status: session.status),
          const SizedBox(height: AppDimensions.md),

          // Info rows
          _InfoRow(
            icon: Icons.location_on_outlined,
            text: session.venueName,
          ),
          const SizedBox(height: AppDimensions.xs),
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            text: Formatters.formatDate(session.date),
          ),
          const SizedBox(height: AppDimensions.xs),
          _InfoRow(
            icon: Icons.access_time_outlined,
            text: Formatters.formatTimeRange(
              session.startTime,
              session.endTime,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          _InfoRow(
            icon: Icons.attach_money_outlined,
            text: '${Formatters.formatRupiah(session.pricePerPerson)} / orang',
          ),
        ],
      ),
    );
  }
}

class _SessionStatusPill extends StatelessWidget {
  const _SessionStatusPill({required this.status});

  final OpenSessionStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(status);
    final label = _statusLabel(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.neutral400),
        const SizedBox(width: AppDimensions.sm),
        Expanded(child: Text(text, style: AppTypography.bodyMedium)),
      ],
    );
  }
}

// ── 2. Health Summary Strip ─────────────────────────────────────────────────

class _HealthSummaryStrip extends StatelessWidget {
  const _HealthSummaryStrip({required this.session});

  final OpenSession session;

  @override
  Widget build(BuildContext context) {
    final isFull = session.currentPlayers >= session.maxPlayers;
    final fillColor = isFull ? AppColors.success : AppColors.primary;

    final hasPending = session.health.pendingPayments > 0;
    final pendingColor = hasPending ? AppColors.warning : AppColors.success;

    final settlementColor = _settlementColor(session.settlementStatus);
    final settlementLabel = _settlementLabel(session.settlementStatus);

    return Row(
      children: [
        Expanded(
          child: _HealthCard(
            label: 'Peserta',
            value: '${session.currentPlayers}/${session.maxPlayers}',
            color: fillColor,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _HealthCard(
            label: 'Tertunda',
            value: '${session.health.pendingPayments}',
            color: pendingColor,
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: _HealthCard(
            label: 'Settlement',
            value: settlementLabel,
            color: settlementColor,
          ),
        ),
      ],
    );
  }

  Color _settlementColor(SessionSettlementStatus status) {
    return switch (status) {
      SessionSettlementStatus.pending => AppColors.warning,
      SessionSettlementStatus.cleared => AppColors.info,
      SessionSettlementStatus.paidOut => AppColors.success,
    };
  }

  String _settlementLabel(SessionSettlementStatus status) {
    return switch (status) {
      SessionSettlementStatus.pending => 'Tertunda',
      SessionSettlementStatus.cleared => 'Tersedia',
      SessionSettlementStatus.paidOut => 'Dibayarkan',
    };
  }
}

class _HealthCard extends StatelessWidget {
  const _HealthCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.sm),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTypography.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── 3. Action Buttons Row ───────────────────────────────────────────────────

class _ActionButtonsRow extends StatelessWidget {
  const _ActionButtonsRow({
    required this.sessionId,
    required this.actions,
  });

  final String sessionId;
  final ParticipantManagementController actions;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TonalActionButton(
            icon: Icons.notifications_active_outlined,
            label: 'Kirim Pengingat',
            onPressed: () => _showTemplatePicker(
              context,
              onTemplate: (templateCode) => actions.sendMessage(
                sessionId: sessionId,
                templateCode: templateCode,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          _TonalActionButton(
            icon: Icons.share_outlined,
            label: 'Bagikan',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur berbagi akan segera hadir'),
                ),
              );
            },
          ),
          const SizedBox(width: AppDimensions.sm),
          _TonalActionButton(
            icon: Icons.copy_outlined,
            label: 'Duplikat',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur duplikasi akan segera hadir'),
                ),
              );
            },
          ),
          const SizedBox(width: AppDimensions.sm),
          _TonalActionButton(
            icon: Icons.cancel_outlined,
            label: 'Batalkan',
            foregroundColor: AppColors.error,
            onPressed: () => _showReasonDialog(
              context,
              title: 'Batalkan Sesi',
              label: 'Alasan pembatalan',
              onSubmit: (reason) => actions.cancelSession(
                sessionId: sessionId,
                reason: reason,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TonalActionButton extends StatelessWidget {
  const _TonalActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        foregroundColor: foregroundColor,
        visualDensity: VisualDensity.compact,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
    );
  }
}

// ── 4. Participant Roster ───────────────────────────────────────────────────

class _ParticipantRoster extends ConsumerWidget {
  const _ParticipantRoster({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final participantsAsync = ref.watch(
      organizerParticipantsProvider(sessionId),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text('Peserta', style: AppTypography.titleMedium),
            const Spacer(),
            AsyncValueWidget(
              value: participantsAsync,
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (participants) => CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Text(
                  '${participants.length}',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),

        // Participant list
        AsyncValueWidget(
          value: participantsAsync,
          data: (participants) {
            if (participants.isEmpty) {
              return const EmptyState(
                message: 'Belum ada peserta',
                icon: Icons.group_off_outlined,
              );
            }
            return Column(
              children: participants.map((participant) {
                return _ParticipantRow(
                  participant: participant,
                  sessionId: sessionId,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ParticipantRow extends ConsumerWidget {
  const _ParticipantRow({
    required this.participant,
    required this.sessionId,
  });

  final SessionParticipant participant;
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initials = _getInitials(participant.playerName);

    return GestureDetector(
      onTap: () => _showParticipantActions(context, ref),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        margin: const EdgeInsets.only(bottom: AppDimensions.sm),
        decoration: BoxDecoration(
          color: AppSurfaces.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary50,
              child: Text(
                initials,
                style: AppTypography.titleSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.playerName,
                    style: AppTypography.titleSmall,
                  ),
                  Text(
                    'Bergabung ${Formatters.formatDate(participant.joinedAt)}',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ),
            _ParticipantStatusChip(status: participant.status),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
  }

  void _showParticipantActions(BuildContext context, WidgetRef ref) {
    final actions = ref.read(participantManagementProvider);

    showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.base),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(participant.playerName, style: AppTypography.titleMedium),
              Text(
                _participantStatusLabel(participant.status),
                style: AppTypography.caption,
              ),

              // Payment proof preview — only when participant uploaded one.
              // Matches the web AdminSessionDetail lightbox pattern: small
              // thumbnail in-list, tap opens an InteractiveViewer dialog.
              if (participant.evidenceUrl != null &&
                  participant.evidenceUrl!.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.base),
                Text(
                  'Bukti Pembayaran',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                const SizedBox(height: AppDimensions.xs),
                GestureDetector(
                  onTap: () {
                    final url = participant.evidenceUrl!;
                    showDialog<void>(
                      context: context,
                      builder: (dlg) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(dlg),
                          child: InteractiveViewer(
                            child: Image.network(url, cacheWidth: 2048),
                          ),
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusMd),
                    child: Image.network(
                      participant.evidenceUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      cacheHeight: 280,
                      errorBuilder: (_, _, _) => Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.neutral100,
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_outlined,
                            color: AppColors.neutral400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: AppDimensions.base),
              ..._buildContextualActions(ctx, actions),

              // Attendance section — for confirmed participants with a
              // session_student id (bookingId). Calls
              // PATCH /v1/admin/session-students/{id}/attendance.
              if (participant.status == SessionParticipantStatus.confirmed &&
                  participant.bookingId != null) ...[
                const SizedBox(height: AppDimensions.base),
                const Divider(),
                const SizedBox(height: AppDimensions.sm),
                Text('Kehadiran', style: AppTypography.titleSmall),
                const SizedBox(height: AppDimensions.sm),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await actions.setAttendance(
                            bookingId: participant.bookingId!,
                            sessionId: sessionId,
                            status: 'present',
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tercatat: Hadir'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_outline,
                            size: 16),
                        label: const Text('Hadir'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.success,
                          side: const BorderSide(color: AppColors.success),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await actions.setAttendance(
                            bookingId: participant.bookingId!,
                            sessionId: sessionId,
                            status: 'late',
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tercatat: Telat'),
                              backgroundColor: AppColors.warning,
                            ),
                          );
                        },
                        icon: const Icon(Icons.schedule, size: 16),
                        label: const Text('Telat'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.warning,
                          side: const BorderSide(color: AppColors.warning),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          Navigator.pop(ctx);
                          await actions.setAttendance(
                            bookingId: participant.bookingId!,
                            sessionId: sessionId,
                            status: 'absent',
                          );
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tercatat: Absen'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 16),
                        label: const Text('Absen'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: AppDimensions.sm),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur pesan akan segera hadir'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.message_outlined),
                  label: const Text('Kirim Pesan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildContextualActions(
    BuildContext ctx,
    ParticipantManagementController actions,
  ) {
    final parentContext = ctx;

    switch (participant.status) {
      case SessionParticipantStatus.pendingPayment:
        return [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () async {
                Navigator.pop(parentContext);
                await actions.confirm(
                  participantId: participant.id,
                  sessionId: sessionId,
                );
              },
              child: const Text('Tandai Lunas'),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(parentContext);
                _showReasonDialog(
                  parentContext,
                  title: 'Tolak Peserta',
                  label: 'Alasan penolakan',
                  onSubmit: (reason) => actions.reject(
                    participantId: participant.id,
                    sessionId: sessionId,
                    reason: reason,
                  ),
                );
              },
              child: const Text('Tolak'),
            ),
          ),
        ];
      case SessionParticipantStatus.confirmed:
        return [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () async {
                Navigator.pop(parentContext);
                await actions.noShow(
                  participantId: participant.id,
                  sessionId: sessionId,
                );
              },
              child: const Text('Tandai No Show'),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.pop(parentContext);
                _showReasonDialog(
                  parentContext,
                  title: 'Ajukan Refund',
                  label: 'Alasan refund',
                  onSubmit: (reason) => actions.refund(
                    participantId: participant.id,
                    sessionId: sessionId,
                    reason: reason,
                  ),
                );
              },
              child: const Text('Ajukan Refund'),
            ),
          ),
        ];
      case SessionParticipantStatus.disputed:
        return [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(parentContext);
                _showReasonDialog(
                  parentContext,
                  title: 'Selesaikan Komplain',
                  label: 'Resolusi',
                  onSubmit: (resolution) => actions.resolveDispute(
                    participantId: participant.id,
                    sessionId: sessionId,
                    resolution: resolution,
                  ),
                );
              },
              child: const Text('Selesaikan Komplain'),
            ),
          ),
        ];
      default:
        return [];
    }
  }
}

class _ParticipantStatusChip extends StatelessWidget {
  const _ParticipantStatusChip({required this.status});

  final SessionParticipantStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _participantStatusColor(status);
    final label = _participantStatusLabel(status);
    final isRefunded = status == SessionParticipantStatus.refunded;
    final isDisputed = status == SessionParticipantStatus.disputed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDisputed
            ? color
            : isRefunded
                ? Colors.transparent
                : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: isRefunded ? Border.all(color: color) : null,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(
          color: isDisputed ? AppColors.textOnPrimary : color,
        ),
      ),
    );
  }

  Color _participantStatusColor(SessionParticipantStatus status) {
    return switch (status) {
      SessionParticipantStatus.pendingPayment => AppColors.warning,
      SessionParticipantStatus.confirmed => AppColors.success,
      SessionParticipantStatus.rejected => AppColors.error,
      SessionParticipantStatus.cancelledByPlayer => AppColors.neutral400,
      SessionParticipantStatus.refunded => AppColors.error,
      SessionParticipantStatus.noShow => AppColors.neutral600,
      SessionParticipantStatus.disputed => AppColors.error,
    };
  }
}

// ── 5. Settlement Section ───────────────────────────────────────────────────

class _SettlementSection extends ConsumerWidget {
  const _SettlementSection({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final earningsAsync = ref.watch(organizerEarningsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Settlement', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.sm),
        AsyncValueWidget(
          value: earningsAsync,
          data: (earnings) {
            final settlement = earnings.settlements.firstWhere(
              (s) => s.sessionId == sessionId,
              orElse: () => earnings.settlements.first,
            );

            final settlementColor = _settlementStatusColor(
              settlement.settlementStatus,
            );
            final settlementLabel = _settlementStatusLabel(
              settlement.settlementStatus,
            );

            return Container(
              padding: const EdgeInsets.all(AppDimensions.base),
              decoration: BoxDecoration(
                color: AppSurfaces.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                boxShadow: AppShadows.xs,
              ),
              child: Column(
                children: [
                  _SettlementRow(
                    label: 'Pendapatan Kotor',
                    value: Formatters.formatRupiah(settlement.grossRevenue),
                  ),
                  const SizedBox(height: AppDimensions.xs),
                  _SettlementRow(
                    label: 'Estimasi Biaya',
                    value:
                        '- ${Formatters.formatRupiah(settlement.estimatedCost)}',
                    valueColor: AppColors.error,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: AppDimensions.sm,
                    ),
                    child: Divider(height: 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pendapatan Bersih',
                        style: AppTypography.titleSmall,
                      ),
                      Text(
                        Formatters.formatRupiah(settlement.netRevenue),
                        style: AppTypography.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: settlementColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: Text(
                        settlementLabel,
                        style: AppTypography.labelSmall.copyWith(
                          color: settlementColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Color _settlementStatusColor(SessionSettlementStatus status) {
    return switch (status) {
      SessionSettlementStatus.pending => AppColors.warning,
      SessionSettlementStatus.cleared => AppColors.info,
      SessionSettlementStatus.paidOut => AppColors.success,
    };
  }

  String _settlementStatusLabel(SessionSettlementStatus status) {
    return switch (status) {
      SessionSettlementStatus.pending => 'Tertunda',
      SessionSettlementStatus.cleared => 'Tersedia',
      SessionSettlementStatus.paidOut => 'Dibayarkan',
    };
  }
}

class _SettlementRow extends StatelessWidget {
  const _SettlementRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.bodyMedium),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _statusColor(OpenSessionStatus status) {
  return switch (status) {
    OpenSessionStatus.open => AppColors.primary,
    OpenSessionStatus.full => AppColors.warning,
    OpenSessionStatus.confirmed => AppColors.success,
    OpenSessionStatus.cancelled => AppColors.error,
    OpenSessionStatus.completed => AppColors.neutral400,
  };
}

String _statusLabel(OpenSessionStatus status) {
  return switch (status) {
    OpenSessionStatus.open => 'Terjadwal',
    OpenSessionStatus.full => 'Penuh',
    OpenSessionStatus.confirmed => 'Terkonfirmasi',
    OpenSessionStatus.cancelled => 'Dibatalkan',
    OpenSessionStatus.completed => 'Selesai',
  };
}

String _participantStatusLabel(SessionParticipantStatus status) {
  return switch (status) {
    SessionParticipantStatus.pendingPayment => 'Menunggu Bayar',
    SessionParticipantStatus.confirmed => 'Terkonfirmasi',
    SessionParticipantStatus.rejected => 'Ditolak',
    SessionParticipantStatus.cancelledByPlayer => 'Dibatalkan',
    SessionParticipantStatus.refunded => 'Refund',
    SessionParticipantStatus.noShow => 'No Show',
    SessionParticipantStatus.disputed => 'Komplain',
  };
}

Future<void> _showReasonDialog(
  BuildContext context, {
  required String title,
  required String label,
  required Future<void> Function(String) onSubmit,
}) async {
  final controller = TextEditingController();
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () async {
            final reason = controller.text.trim();
            if (reason.isEmpty) return;
            Navigator.pop(ctx);
            await onSubmit(reason);
          },
          child: const Text('Simpan'),
        ),
      ],
    ),
  );
  controller.dispose();
}

Future<void> _showTemplatePicker(
  BuildContext context, {
  required Future<void> Function(String) onTemplate,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: const Text('Mulai dalam 2 jam'),
            onTap: () async {
              Navigator.pop(ctx);
              await onTemplate('starts_in_2h');
            },
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz_outlined),
            title: const Text('Lapangan berubah'),
            onTap: () async {
              Navigator.pop(ctx);
              await onTemplate('court_changed');
            },
          ),
          ListTile(
            leading: const Icon(Icons.payment_outlined),
            title: const Text('Pengingat pembayaran'),
            onTap: () async {
              Navigator.pop(ctx);
              await onTemplate('payment_reminder');
            },
          ),
        ],
      ),
    ),
  );
}
