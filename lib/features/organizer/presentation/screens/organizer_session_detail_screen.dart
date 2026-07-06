import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/app_haptics.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/payment_proof_sheet.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/session_detail_hero.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/session_health_strip.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/session_settlement_card.dart';
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
        actions: [
          if (sessionAsync.valueOrNull != null &&
              sessionAsync.value!.status != OpenSessionStatus.cancelled &&
              sessionAsync.value!.status != OpenSessionStatus.completed)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit sesi',
              onPressed: () =>
                  context.push(AppRoutes.organizerEditSession(sessionId)),
            ),
        ],
      ),
      body: AsyncValueWidget(
        value: sessionAsync,
        data: (session) {
          return ListView(
            padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
            children: [
              // 1. Sport-tinted hero card
              SessionDetailHero(session: session),
              const SizedBox(height: AppDimensions.lg),

              // 2. Health strip
              SessionHealthStrip(session: session),
              const SizedBox(height: AppDimensions.lg),

              // 3. Settlement (money first — design intent)
              _SettlementSection(sessionId: sessionId),
              const SizedBox(height: AppDimensions.lg),

              // 4. Participant roster + batch confirm CTA
              _ParticipantRoster(sessionId: sessionId),
              const SizedBox(height: AppDimensions.lg),

              // 5. Action pills (Kirim Pengingat / Batalkan)
              _ActionButtonsRow(
                sessionId: sessionId,
                actions: ref.read(participantManagementProvider),
              ),
              const SizedBox(height: AppDimensions.huge),
            ],
          );
        },
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
    // Bagikan + Duplikat hidden as stubs per PRD §6 reduce-stub-debt rule.
    // Re-add when actual implementations exist.
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showTemplatePicker(
              context,
              onTemplate: (templateCode) => actions.sendMessage(
                sessionId: sessionId,
                templateCode: templateCode,
              ),
            ),
            icon: const Icon(
              Icons.notifications_active_outlined,
              size: 16,
            ),
            label: const Text('Kirim Pengingat'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.sm),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showReasonDialog(
              context,
              title: 'Batalkan Sesi',
              label: 'Alasan pembatalan',
              onSubmit: (reason) => actions.cancelSession(
                sessionId: sessionId,
                reason: reason,
              ),
            ),
            icon: const Icon(Icons.cancel_outlined, size: 16),
            label: const Text('Batalkan'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.errorDark,
              backgroundColor: AppColors.errorLight,
              side: BorderSide(
                color: AppColors.error.withValues(alpha: 0.4),
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
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
            final pendingCount = participants
                .where(
                  (p) => p.status == SessionParticipantStatus.pendingPayment,
                )
                .length;

            return Column(
              children: [
                ...participants.map(
                  (participant) => _ParticipantRow(
                    participant: participant,
                    sessionId: sessionId,
                  ),
                ),
                if (pendingCount > 0) ...[
                  const SizedBox(height: AppDimensions.sm),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => context.push(
                        AppRoutes.organizerParticipants(sessionId),
                      ),
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        'Konfirmasi Semua Pembayaran ($pendingCount)',
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusMd,
                          ),
                        ),
                        textStyle: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
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

    // Pending payment uses the redesigned PaymentProofSheet (PR 4c):
    // proof preview front-and-center, claimed amount vs expected check,
    // dual Tolak / Tandai Lunas buttons. Other statuses keep the generic
    // sheet (existing flow) since their actions don't share the same
    // payment-confirmation chrome.
    if (participant.status == SessionParticipantStatus.pendingPayment) {
      final sessionData =
          ref.read(organizerSessionDetailProvider(sessionId)).valueOrNull;
      final expectedAmount = sessionData?.pricing?.effectivePrice ??
          sessionData?.pricePerPerson ??
          0;
      final sessionTitle = sessionData?.safeTitle ?? 'Sesi';
      PaymentProofSheet.show(
        context: context,
        participant: participant,
        sessionTitle: sessionTitle,
        expectedAmount: expectedAmount,
        onConfirm: () => actions.confirm(
          participantId: participant.id,
          sessionId: sessionId,
        ),
        onReject: () => _showReasonDialog(
          context,
          title: 'Tolak Peserta',
          label: 'Alasan penolakan',
          onSubmit: (reason) => actions.reject(
            participantId: participant.id,
            sessionId: sessionId,
            reason: reason,
          ),
        ),
      );
      return;
    }

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

/// Replaces the old `organizerEarningsProvider` settlement (which
/// hardcoded `estimated_cost: 0`) with the live financial snapshot from
/// `SessionFinancialService::forSession`. Uses the redesigned
/// [SessionSettlementCard] (prominent net + group rows).
class _SettlementSection extends ConsumerWidget {
  const _SettlementSection({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financialAsync = ref.watch(sessionFinancialProvider(sessionId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Rincian keuangan',
              style: AppTypography.titleMedium.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: AppDimensions.sm),
            Text(
              'Estimasi · belum selesai',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.sm),
        AsyncValueWidget(
          value: financialAsync,
          data: (fin) => SessionSettlementCard(financial: fin),
        ),
      ],
    );
  }
}

// ── Shared helpers ──────────────────────────────────────────────────────────

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
            AppHaptics.tap();
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
