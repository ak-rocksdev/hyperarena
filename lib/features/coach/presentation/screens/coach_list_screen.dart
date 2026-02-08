import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/coach/presentation/widgets/coach_card.dart';
import 'package:hyperarena/features/coach/providers/coach_providers.dart';

class CoachListScreen extends ConsumerWidget {
  final String searchQuery;
  const CoachListScreen({super.key, this.searchQuery = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(coachFilterProvider);
    final coachList = ref.watch(coachListProvider);

    return Column(
      children: [
        // Sport filter chips
        SizedBox(
          height: AppDimensions.chipHeight + AppDimensions.base,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.sm,
            ),
            children: Sport.values.map((sport) {
              return Padding(
                padding: const EdgeInsets.only(right: AppDimensions.sm),
                child: SportChipSelector(
                  sport: sport,
                  isSelected: filter == sport,
                  onToggle: (_) =>
                      ref.read(coachFilterProvider.notifier).setSport(sport),
                ),
              );
            }).toList(),
          ),
        ),

        // Coach list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(coachListProvider.future),
            child: AsyncValueWidget(
              value: coachList,
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                itemCount: 3,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 160),
                ),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(coachListProvider),
              ),
              data: (coaches) {
                var filtered = coaches;
                if (searchQuery.isNotEmpty) {
                  filtered = coaches
                      .where((c) =>
                          c.name.toLowerCase().contains(searchQuery) ||
                          c.city.toLowerCase().contains(searchQuery) ||
                          c.sports.any((s) =>
                              s.name.toLowerCase().contains(searchQuery)))
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada coach ditemukan',
                    icon: Icons.school_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: CoachCard(coach: filtered[i]),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
