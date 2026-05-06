import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_theme_extensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/data/models/assessment.dart';
import 'package:hyperarena/features/coach/presentation/widgets/radar_chart_widget.dart';
import 'package:hyperarena/features/profile/providers/career_provider.dart';
import 'package:hyperarena/features/review/data/models/review.dart';
import 'package:hyperarena/features/review/presentation/widgets/rating_stars.dart';

class CareerScreen extends ConsumerStatefulWidget {
  const CareerScreen({super.key});

  static const _currentPlayerId = 'user-001';

  @override
  ConsumerState<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends ConsumerState<CareerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Sport? _selectedSport;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perkembangan Saya'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Penilaian'),
            Tab(text: 'Ulasan Saya'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAssessmentsTab(),
          _buildReviewsTab(),
        ],
      ),
    );
  }

  Widget _buildAssessmentsTab() {
    final assessmentsAsync = ref.watch(
      playerAssessmentsProvider(CareerScreen._currentPlayerId),
    );
    final latestPerSportAsync = ref.watch(
      latestAssessmentPerSportProvider(CareerScreen._currentPlayerId),
    );

    return AsyncValueWidget(
      value: assessmentsAsync,
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(
          playerAssessmentsProvider(CareerScreen._currentPlayerId),
        ),
      ),
      data: (assessments) {
        if (assessments.isEmpty) {
          return _buildEmptyState(
            icon: Icons.assessment_outlined,
            message: 'Belum ada penilaian dari coach',
          );
        }

        final sportMap = latestPerSportAsync.valueOrNull ?? {};
        final sports = sportMap.keys.toList();
        _selectedSport ??= sports.isNotEmpty ? sports.first : null;
        final latestForSport = _selectedSport != null
            ? sportMap[_selectedSport]
            : null;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sport tabs
              if (sports.length > 1) ...[
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sports.map((sport) {
                      final selected = _selectedSport == sport;
                      return Padding(
                        padding: const EdgeInsets.only(
                          right: AppDimensions.sm,
                        ),
                        child: ChoiceChip(
                          label: Text(SportChipSelector.sportLabel(sport)),
                          selected: selected,
                          onSelected: (_) =>
                              setState(() => _selectedSport = sport),
                          selectedColor: AppColors.primary50,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppDimensions.base),
              ],

              // Radar chart
              if (latestForSport != null) ...[
                Center(
                  child: RadarChartWidget(
                    size: 220,
                    values: [
                      latestForSport.technique / 10,
                      latestForSport.stamina / 10,
                      latestForSport.tactics / 10,
                      latestForSport.mentality / 10,
                      latestForSport.consistency / 10,
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.xl),

                // Skill breakdown bars
                _buildSkillBar('Teknik', latestForSport.technique),
                _buildSkillBar('Stamina', latestForSport.stamina),
                _buildSkillBar('Taktik', latestForSport.tactics),
                _buildSkillBar('Mental', latestForSport.mentality),
                _buildSkillBar('Konsistensi', latestForSport.consistency),
                const SizedBox(height: AppDimensions.base),

                // Recommended level
                _buildRecommendedLevel(context, latestForSport),
                const SizedBox(height: AppDimensions.base),

                // Improvement notes
                if (latestForSport.whatToImprove != null ||
                    latestForSport.playingStyleNotes != null ||
                    latestForSport.strengthHighlight != null)
                  _buildImprovementNotes(latestForSport),

                const SizedBox(height: AppDimensions.xl),
              ],

              // Assessment timeline
              Text('Riwayat Penilaian', style: AppTypography.titleMedium),
              const SizedBox(height: AppDimensions.md),
              ...assessments.map((a) => _buildAssessmentTimelineItem(a)),
              const SizedBox(height: AppDimensions.screenBottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    final reviewsAsync = ref.watch(playerWrittenReviewsProvider);

    return AsyncValueWidget(
      value: reviewsAsync,
      error: (e, _) => ErrorView(
        error: e,
        onRetry: () => ref.invalidate(playerWrittenReviewsProvider),
      ),
      data: (reviews) {
        if (reviews.isEmpty) {
          return _buildEmptyState(
            icon: Icons.rate_review_outlined,
            message: 'Belum ada ulasan yang ditulis',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          itemCount: reviews.length,
          itemBuilder: (_, i) => _buildReviewItem(reviews[i]),
        );
      },
    );
  }

  Widget _buildSkillBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.sm),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: AppTypography.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: value / 10,
                minHeight: 8,
                backgroundColor: AppColors.neutral100,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.sm),
          SizedBox(
            width: 24,
            child: Text(
              '$value',
              style: AppTypography.numberSmall.copyWith(
                color: AppColors.primary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedLevel(BuildContext context, Assessment assessment) {
    final gamification =
        Theme.of(context).extension<GamificationThemeExtension>()!;
    return Container(
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: gamification
            .levelBackgroundColor(assessment.recommendedLevel),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: gamification.levelColor(assessment.recommendedLevel),
          ),
          const SizedBox(width: AppDimensions.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Level Rekomendasi Coach',
                style: AppTypography.labelSmall.copyWith(
                  color: gamification
                      .levelTextColor(assessment.recommendedLevel),
                ),
              ),
              Text(
                GamificationHelpers.tierLabel(assessment.recommendedLevel),
                style: AppTypography.titleSmall.copyWith(
                  color: gamification
                      .levelTextColor(assessment.recommendedLevel),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImprovementNotes(Assessment assessment) {
    return ExpansionTile(
      title: Text(
        'Catatan dari Coach',
        style: AppTypography.titleSmall,
      ),
      initiallyExpanded: false,
      childrenPadding: const EdgeInsets.only(
        left: AppDimensions.base,
        right: AppDimensions.base,
        bottom: AppDimensions.base,
      ),
      children: [
        if (assessment.strengthHighlight != null)
          _buildNoteItem(
            icon: Icons.star_outline,
            label: 'Kelebihan Utama',
            value: assessment.strengthHighlight!,
            color: AppColors.success,
          ),
        if (assessment.whatToImprove != null)
          _buildNoteItem(
            icon: Icons.trending_up,
            label: 'Yang Perlu Diperbaiki',
            value: assessment.whatToImprove!,
            color: AppColors.accent,
          ),
        if (assessment.playingStyleNotes != null)
          _buildNoteItem(
            icon: Icons.sports,
            label: 'Gaya Bermain',
            value: assessment.playingStyleNotes!,
            color: AppColors.primary,
          ),
      ],
    );
  }

  Widget _buildNoteItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppDimensions.iconSm, color: color),
          const SizedBox(width: AppDimensions.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTypography.labelSmall.copyWith(color: color),
                ),
                const SizedBox(height: AppDimensions.xxs),
                Text(value, style: AppTypography.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentTimelineItem(Assessment a) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Row(
        children: [
          // Mini radar
          SizedBox(
            width: 48,
            height: 48,
            child: RadarChartWidget(
              size: 48,
              values: [
                a.technique / 10,
                a.stamina / 10,
                a.tactics / 10,
                a.mentality / 10,
                a.consistency / 10,
              ],
              labels: const ['', '', '', '', ''],
            ),
          ),
          const SizedBox(width: AppDimensions.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.coachName,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (a.sessionTitle != null)
                  Text(
                    a.sessionTitle!,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                Text(
                  Formatters.formatDate(a.date),
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.neutral400,
                  ),
                ),
              ],
            ),
          ),
          Text(
            ((a.technique + a.stamina + a.tactics + a.mentality + a.consistency) / 5).toStringAsFixed(1),
            style: AppTypography.numberMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Review r) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.md),
      padding: const EdgeInsets.all(AppDimensions.base),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        boxShadow: AppShadows.xs,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.coachName ?? 'Coach',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                Formatters.formatDate(r.createdAt),
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.neutral400,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.xs),
          Text(
            r.sessionTitle ?? '',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          RatingStars(rating: r.rating, size: 16),
          if (r.comment != null && r.comment!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.sm),
            Text(
              r.comment!,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.neutral600,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppDimensions.iconXl, color: AppColors.neutral500),
          const SizedBox(height: AppDimensions.base),
          Text(
            message,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.neutral600,
            ),
          ),
        ],
      ),
    );
  }
}
