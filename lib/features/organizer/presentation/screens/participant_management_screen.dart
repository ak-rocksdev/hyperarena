import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/organizer/providers/participant_management_provider.dart';
import 'package:hyperarena/features/session/data/models/session_participant.dart';

enum _ParticipantFilter { semua, menunggu, terkonfirmasi, bermasalah }

class ParticipantManagementScreen extends ConsumerStatefulWidget {
  const ParticipantManagementScreen({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<ParticipantManagementScreen> createState() =>
      _ParticipantManagementScreenState();
}

class _ParticipantManagementScreenState
    extends ConsumerState<ParticipantManagementScreen> {
  _ParticipantFilter _selectedFilter = _ParticipantFilter.semua;

  static const _bermasalahStatuses = {
    SessionParticipantStatus.rejected,
    SessionParticipantStatus.refunded,
    SessionParticipantStatus.noShow,
    SessionParticipantStatus.disputed,
  };

  List<SessionParticipant> _applyFilter(List<SessionParticipant> all) {
    return switch (_selectedFilter) {
      _ParticipantFilter.semua => all,
      _ParticipantFilter.menunggu => all
          .where((p) => p.status == SessionParticipantStatus.pendingPayment)
          .toList(),
      _ParticipantFilter.terkonfirmasi => all
          .where((p) => p.status == SessionParticipantStatus.confirmed)
          .toList(),
      _ParticipantFilter.bermasalah =>
        all.where((p) => _bermasalahStatuses.contains(p.status)).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final participantsAsync = ref.watch(
      organizerParticipantsProvider(widget.sessionId),
    );
    final sessionAsync = ref.watch(
      organizerSessionDetailProvider(widget.sessionId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kelola Peserta'),
            sessionAsync.whenOrNull(
                  data: (session) => Text(
                    session.title,
                    style: AppTypography.caption,
                  ),
                ) ??
                const SizedBox.shrink(),
          ],
        ),
      ),
      body: AsyncValueWidget(
        value: participantsAsync,
        data: (allParticipants) {
          if (allParticipants.isEmpty) {
            return const EmptyState(
              message: 'Belum ada peserta pada sesi ini.',
              icon: Icons.group_off_outlined,
            );
          }

          final filtered = _applyFilter(allParticipants);
          final pendingCount = allParticipants
              .where(
                  (p) => p.status == SessionParticipantStatus.pendingPayment)
              .length;
          final confirmedCount = allParticipants
              .where((p) => p.status == SessionParticipantStatus.confirmed)
              .length;
          final refundCount = allParticipants
              .where((p) => p.status == SessionParticipantStatus.refunded)
              .length;

          return Column(
            children: [
              // Filter chips
              _FilterChipRow(
                selected: _selectedFilter,
                onSelected: (f) => setState(() => _selectedFilter = f),
              ),

              // Batch actions
              if (pendingCount > 0)
                _BatchActionsSection(
                  pendingCount: pendingCount,
                  sessionId: widget.sessionId,
                  allParticipants: allParticipants,
                ),

              // Participant list
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyState(
                        message: 'Tidak ada peserta dengan filter ini.',
                        icon: Icons.filter_list_off_outlined,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.screenHorizontal,
                          vertical: AppDimensions.sm,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => _ParticipantCard(
                          participant: filtered[index],
                          sessionId: widget.sessionId,
                        ),
                      ),
              ),

              // Stats bar
              _StatsBar(
                confirmedCount: confirmedCount,
                totalCount: allParticipants.length,
                pendingCount: pendingCount,
                refundCount: refundCount,
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Filter Chip Row ──────────────────────────────────────────────────────

class _FilterChipRow extends StatelessWidget {
  const _FilterChipRow({
    required this.selected,
    required this.onSelected,
  });

  final _ParticipantFilter selected;
  final ValueChanged<_ParticipantFilter> onSelected;

  static const _labels = {
    _ParticipantFilter.semua: 'Semua',
    _ParticipantFilter.menunggu: 'Menunggu',
    _ParticipantFilter.terkonfirmasi: 'Terkonfirmasi',
    _ParticipantFilter.bermasalah: 'Bermasalah',
  };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.sm,
      ),
      child: Row(
        children: _ParticipantFilter.values.map((filter) {
          final isSelected = filter == selected;
          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.sm),
            child: ChoiceChip(
              label: Text(_labels[filter]!),
              selected: isSelected,
              onSelected: (_) => onSelected(filter),
              selectedColor: AppColors.primary50,
              labelStyle: AppTypography.labelMedium.copyWith(
                color: isSelected ? AppColors.primary : AppColors.neutral600,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.neutral200,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ── Batch Actions Section ────────────────────────────────────────────────

class _BatchActionsSection extends ConsumerWidget {
  const _BatchActionsSection({
    required this.pendingCount,
    required this.sessionId,
    required this.allParticipants,
  });

  final int pendingCount;
  final String sessionId;
  final List<SessionParticipant> allParticipants;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(participantManagementProvider);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.xs,
      ),
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilledButton.icon(
            onPressed: () async {
              final pending = allParticipants.where(
                (p) => p.status == SessionParticipantStatus.pendingPayment,
              );
              for (final p in pending) {
                await actions.confirm(
                  participantId: p.id,
                  sessionId: sessionId,
                );
              }
            },
            icon: const Icon(Icons.check_circle_outline, size: 18),
            label: Text('Konfirmasi Semua Pembayaran ($pendingCount)'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          OutlinedButton.icon(
            onPressed: () => actions.sendMessage(
              sessionId: sessionId,
              templateCode: 'payment_reminder',
              pendingOnly: true,
            ),
            icon: const Icon(Icons.notifications_outlined, size: 18),
            label: const Text('Kirim Pengingat Pembayaran'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Participant Card ─────────────────────────────────────────────────────

class _ParticipantCard extends ConsumerWidget {
  const _ParticipantCard({
    required this.participant,
    required this.sessionId,
  });

  final SessionParticipant participant;
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.sm),
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info row
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary50,
                child: Text(
                  Formatters.initials(participant.playerName),
                  style: AppTypography.labelMedium.copyWith(
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
                      participant.playerName,
                      style: AppTypography.titleSmall,
                    ),
                    const SizedBox(height: AppDimensions.xxs),
                    Text(
                      'Bergabung ${Formatters.formatDate(participant.joinedAt)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              ),
              _StatusChip(status: participant.status),
            ],
          ),

          // Payment proof image (if available)
          if (participant.evidenceUrl != null &&
              participant.evidenceUrl!.isNotEmpty)
            _PaymentProofSection(evidenceUrl: participant.evidenceUrl!),

          // Inline action buttons
          _InlineActions(
            participant: participant,
            sessionId: sessionId,
          ),

          // Attendance toggle — only for confirmed (paid) participants.
          if (participant.status == SessionParticipantStatus.confirmed &&
              participant.bookingId != null)
            _AttendanceRow(
              bookingId: participant.bookingId!,
              sessionId: sessionId,
            ),
        ],
      ),
    );
  }
}

/// Admin attendance toggle. Each tap sends `PATCH /admin/session-students/{id}/attendance`.
class _AttendanceRow extends ConsumerStatefulWidget {
  const _AttendanceRow({
    required this.bookingId,
    required this.sessionId,
  });

  final String bookingId;
  final String sessionId;

  @override
  ConsumerState<_AttendanceRow> createState() => _AttendanceRowState();
}

class _AttendanceRowState extends ConsumerState<_AttendanceRow> {
  bool _saving = false;

  Future<void> _set(String status) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(participantManagementProvider).setAttendance(
            bookingId: widget.bookingId,
            sessionId: widget.sessionId,
            status: status,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kehadiran disimpan: ${_label(status)}'),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan kehadiran: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _label(String status) => switch (status) {
        'present' => 'Hadir',
        'late' => 'Telat',
        'absent' => 'Absen',
        _ => status,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kehadiran',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : () => _set('present'),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text('Hadir'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    minimumSize: const Size(0, AppDimensions.buttonHeightSm),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : () => _set('late'),
                  icon: const Icon(Icons.schedule, size: 16),
                  label: const Text('Telat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.warning,
                    side: const BorderSide(color: AppColors.warning),
                    minimumSize: const Size(0, AppDimensions.buttonHeightSm),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saving ? null : () => _set('absent'),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text('Absen'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    minimumSize: const Size(0, AppDimensions.buttonHeightSm),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Status Chip ──────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final SessionParticipantStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bgColor, textColor, borderColor) = _chipStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: borderColor != null ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: textColor),
      ),
    );
  }

  static (String, Color, Color, Color?) _chipStyle(
    SessionParticipantStatus status,
  ) {
    return switch (status) {
      SessionParticipantStatus.pendingPayment => (
        'Menunggu Bayar',
        AppColors.warning.withValues(alpha: 0.1),
        AppColors.warningDark,
        null,
      ),
      SessionParticipantStatus.confirmed => (
        'Terkonfirmasi',
        AppColors.success.withValues(alpha: 0.1),
        AppColors.successDark,
        null,
      ),
      SessionParticipantStatus.rejected => (
        'Ditolak',
        AppColors.error.withValues(alpha: 0.1),
        AppColors.errorDark,
        null,
      ),
      SessionParticipantStatus.cancelledByPlayer => (
        'Dibatalkan',
        AppColors.neutral400.withValues(alpha: 0.1),
        AppColors.neutral600,
        null,
      ),
      SessionParticipantStatus.refunded => (
        'Refund',
        Colors.transparent,
        AppColors.errorDark,
        AppColors.error,
      ),
      SessionParticipantStatus.noShow => (
        'No Show',
        AppColors.neutral600.withValues(alpha: 0.1),
        AppColors.neutral700,
        null,
      ),
      SessionParticipantStatus.disputed => (
        'Komplain',
        AppColors.error,
        AppColors.textOnPrimary,
        null,
      ),
    };
  }
}

// ── Payment Proof Section ────────────────────────────────────────────────

class _PaymentProofSection extends StatelessWidget {
  const _PaymentProofSection({required this.evidenceUrl});

  final String evidenceUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bukti Pembayaran',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.neutral600,
            ),
          ),
          const SizedBox(height: AppDimensions.xs),
          GestureDetector(
            onTap: () => _showFullImage(context),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusMd),
              child: Image.network(
                evidenceUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                cacheHeight: 240, // 2x for high-DPI, avoids full-res decode
                errorBuilder: (_, __, ___) => Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.neutral100,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMd,
                    ),
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
      ),
    );
  }

  void _showFullImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => Navigator.pop(ctx),
          child: InteractiveViewer(
            child: Image.network(evidenceUrl, cacheWidth: 2048),
          ),
        ),
      ),
    );
  }
}

// ── Inline Actions ───────────────────────────────────────────────────────

class _InlineActions extends ConsumerWidget {
  const _InlineActions({
    required this.participant,
    required this.sessionId,
  });

  final SessionParticipant participant;
  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(participantManagementProvider);
    final pid = participant.id;

    final buttons = switch (participant.status) {
      SessionParticipantStatus.pendingPayment => [
        FilledButton(
          onPressed: () => actions.confirm(
            participantId: pid,
            sessionId: sessionId,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: const Text('Tandai Lunas'),
        ),
        OutlinedButton(
          onPressed: () => _showReasonDialog(
            context,
            title: 'Tolak Peserta',
            onSubmit: (reason) => actions.reject(
              participantId: pid,
              sessionId: sessionId,
              reason: reason,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: const Text('Tolak'),
        ),
      ],
      SessionParticipantStatus.confirmed => [
        OutlinedButton(
          onPressed: () => actions.noShow(
            participantId: pid,
            sessionId: sessionId,
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.neutral600,
            side: const BorderSide(color: AppColors.neutral400),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: const Text('No Show'),
        ),
        OutlinedButton(
          onPressed: () => _showReasonDialog(
            context,
            title: 'Alasan Refund',
            onSubmit: (reason) => actions.refund(
              participantId: pid,
              sessionId: sessionId,
              reason: reason,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: const Text('Refund'),
        ),
      ],
      SessionParticipantStatus.disputed => [
        FilledButton(
          onPressed: () => _showReasonDialog(
            context,
            title: 'Selesaikan Komplain',
            onSubmit: (resolution) => actions.resolveDispute(
              participantId: pid,
              sessionId: sessionId,
              resolution: resolution,
            ),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textOnPrimary,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.md),
            minimumSize: const Size(0, AppDimensions.buttonHeightSm),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            ),
          ),
          child: const Text('Selesaikan'),
        ),
      ],
      _ => <Widget>[],
    };

    if (buttons.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: AppDimensions.md),
      child: Row(
        children: buttons
            .expand((b) => [b, const SizedBox(width: AppDimensions.sm)])
            .toList()
          ..removeLast(),
      ),
    );
  }

  Future<void> _showReasonDialog(
    BuildContext context, {
    required String title,
    required Future<void> Function(String reason) onSubmit,
  }) async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Masukkan alasan'),
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
}

// ── Stats Bar ────────────────────────────────────────────────────────────

class _StatsBar extends StatelessWidget {
  const _StatsBar({
    required this.confirmedCount,
    required this.totalCount,
    required this.pendingCount,
    required this.refundCount,
  });

  final int confirmedCount;
  final int totalCount;
  final int pendingCount;
  final int refundCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenHorizontal,
        vertical: AppDimensions.md,
      ),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        border: const Border(
          top: BorderSide(color: AppColors.neutral200),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            label: 'Terkonfirmasi',
            value: '$confirmedCount/$totalCount',
            color: AppColors.success,
          ),
          _StatItem(
            label: 'Tertunda',
            value: '$pendingCount',
            color: AppColors.warning,
          ),
          _StatItem(
            label: 'Refund',
            value: '$refundCount',
            color: AppColors.error,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTypography.titleSmall.copyWith(color: color),
        ),
        const SizedBox(height: AppDimensions.xxs),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: AppColors.neutral600,
          ),
        ),
      ],
    );
  }
}
