import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/widgets/app_button.dart';

/// Participant row with assessment status.
class _PlayerRow {
  final String playerId;
  final String playerName;
  final bool isAssessed;

  _PlayerRow({
    required this.playerId,
    required this.playerName,
    required this.isAssessed,
  });
}

/// Widget showing session participants with assessment status.
/// Used on coach's view of completed sessions.
class SessionPlayerAssessmentList extends ConsumerWidget {
  final String sessionId;
  final String sessionTitle;
  final Sport sport;
  final DateTime? sessionDate;
  final List<String> participantNames;

  const SessionPlayerAssessmentList({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
    required this.sport,
    this.sessionDate,
    required this.participantNames,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Build player rows with assessment status from mock data
    final assessments = MockData.assessments;
    final rows = participantNames.map((name) {
      // In a real app, participants would have IDs. For mock, derive from name.
      final assessed = assessments.any(
        (a) => a.studentName == name && a.sessionId == sessionId,
      );
      return _PlayerRow(
        playerId: 'user-mock-${name.hashCode}',
        playerName: name,
        isAssessed: assessed,
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Penilaian Peserta', style: AppTypography.titleSmall),
          const SizedBox(height: AppDimensions.md),
          ...rows.map((row) => _buildPlayerRow(context, row)),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(BuildContext context, _PlayerRow row) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          CircleAvatar(
            radius: AppDimensions.avatarSm / 2,
            backgroundColor: AppColors.primary50,
            child: Text(
              row.playerName[0].toUpperCase(),
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary700,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.playerName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  row.isAssessed ? 'Sudah dinilai' : 'Belum dinilai',
                  style: AppTypography.labelSmall.copyWith(
                    color: row.isAssessed
                        ? AppColors.success
                        : AppColors.neutral400,
                  ),
                ),
              ],
            ),
          ),
          if (row.isAssessed)
            TextButton(
              onPressed: () {
                // Navigate to read-only assessment view
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Lihat penilaian (placeholder)'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Lihat',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            )
          else
            SizedBox(
              height: AppDimensions.buttonHeightSm,
              child: AppButton(
                label: 'Beri Penilaian',
                variant: AppButtonVariant.tonal,
                onPressed: () {
                  context.push(
                    '/coach/assessment/new'
                    '?sessionId=$sessionId'
                    '&sessionTitle=${Uri.encodeComponent(sessionTitle)}'
                    '&studentName=${Uri.encodeComponent(row.playerName)}'
                    '&studentId=${row.playerId}'
                    '&sport=${sport.name}',
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
