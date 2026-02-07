import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/features/owner/data/models/court_availability_issue.dart';
import 'package:hyperarena/features/owner/providers/owner_providers.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';
import 'package:hyperarena/features/venue/data/models/venue.dart';

class OwnerVenueDetailScreen extends ConsumerWidget {
  const OwnerVenueDetailScreen({super.key, required this.venueId});

  final String venueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final venueAsync = ref.watch(ownerVenueDetailProvider(venueId));
    final issuesAsync = ref.watch(ownerAvailabilityIssuesProvider);

    return Scaffold(
      appBar: AppBar(
        title: venueAsync.whenOrNull(data: (v) => Text(v.name)) ??
            const Text('Detail Venue'),
      ),
      body: AsyncValueWidget(
        value: venueAsync,
        data: (venue) {
          final venueIssues = issuesAsync.whenOrNull<List<CourtAvailabilityIssue>>(
                data: (issues) =>
                    issues.where((i) => i.venueId == venue.id).toList(),
              ) ??
              [];

          return ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.screenTop,
            ),
            children: [
              // ── Info Section ───────────────────────────────────────
              _VenueInfoSection(venue: venue),
              const SizedBox(height: AppDimensions.xl),

              // ── Court List Section ─────────────────────────────────
              _CourtListSection(
                courts: venue.courts,
                venueIssues: venueIssues,
              ),

              // ── Availability Issues Section ────────────────────────
              if (venueIssues.isNotEmpty) ...[
                const SizedBox(height: AppDimensions.xl),
                _AvailabilityIssuesSection(issues: venueIssues),
              ],
              const SizedBox(height: AppDimensions.xxl),
            ],
          );
        },
      ),
    );
  }
}

// ── Venue Info ────────────────────────────────────────────────────────────────

class _VenueInfoSection extends StatelessWidget {
  const _VenueInfoSection({required this.venue});

  final Venue venue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venue.name, style: AppTypography.titleMedium),
          const SizedBox(height: AppDimensions.sm),
          Text(
            '${venue.city} \u2022 ${venue.address}',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.base),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Edit akan segera hadir'),
                  ),
                );
              },
              icon: const Icon(Icons.edit_outlined, size: AppDimensions.iconSm),
              label: const Text('Edit Info Venue'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Court List ────────────────────────────────────────────────────────────────

class _CourtListSection extends StatelessWidget {
  const _CourtListSection({
    required this.courts,
    required this.venueIssues,
  });

  final List<Court> courts;
  final List<CourtAvailabilityIssue> venueIssues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lapangan (${courts.length})',
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: AppDimensions.md),
        ...courts.map((court) {
          final courtIssues =
              venueIssues.where((i) => i.courtId == court.id).toList();
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.md),
            child: _CourtCard(court: court, issues: courtIssues),
          );
        }),
      ],
    );
  }
}

class _CourtCard extends StatelessWidget {
  const _CourtCard({
    required this.court,
    required this.issues,
  });

  final Court court;
  final List<CourtAvailabilityIssue> issues;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Court name + sport pill
          Row(
            children: [
              Expanded(
                child: Text(
                  court.name,
                  style: AppTypography.titleSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              _SportPill(sportName: court.sportType.name),
            ],
          ),
          const SizedBox(height: AppDimensions.sm),

          // Environment
          Text(court.environment, style: AppTypography.caption),
          const SizedBox(height: AppDimensions.sm),

          // Status pill + inactive issue info
          Row(
            children: [
              _StatusPill(isActive: court.isActive),
              if (!court.isActive && issues.isNotEmpty) ...[
                const SizedBox(width: AppDimensions.sm),
                Expanded(
                  child: Text(
                    '${Formatters.formatDate(issues.first.from)} - ${Formatters.formatDate(issues.first.to)}',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppDimensions.md),

          // Maintenance button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur maintenance akan segera hadir'),
                  ),
                );
              },
              child: const Text('Tandai Tidak Tersedia'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SportPill extends StatelessWidget {
  const _SportPill({required this.sportName});

  final String sportName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.secondary50,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        sportName,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.sm,
        vertical: AppDimensions.xs,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.successLight : AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        isActive ? 'Aktif' : 'Tidak Tersedia',
        style: AppTypography.labelSmall.copyWith(
          color: isActive ? AppColors.successDark : AppColors.errorDark,
        ),
      ),
    );
  }
}

// ── Availability Issues ──────────────────────────────────────────────────────

class _AvailabilityIssuesSection extends StatelessWidget {
  const _AvailabilityIssuesSection({required this.issues});

  final List<CourtAvailabilityIssue> issues;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Masalah Ketersediaan', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.md),
        ...issues.map((issue) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.sm),
            child: _IssueRow(issue: issue),
          );
        }),
      ],
    );
  }
}

class _IssueRow extends StatelessWidget {
  const _IssueRow({required this.issue});

  final CourtAvailabilityIssue issue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: AppSurfaces.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(issue.courtName, style: AppTypography.titleSmall),
          const SizedBox(height: AppDimensions.xs),
          Text(issue.reason, style: AppTypography.bodyMedium),
          const SizedBox(height: AppDimensions.xs),
          Text(
            '${Formatters.formatDate(issue.from)} - ${Formatters.formatDate(issue.to)}',
            style: AppTypography.caption.copyWith(color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
