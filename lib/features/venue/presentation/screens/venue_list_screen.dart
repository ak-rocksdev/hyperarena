import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/venue/presentation/widgets/venue_card.dart';
import 'package:hyperarena/features/venue/providers/venue_providers.dart';

class VenueListScreen extends ConsumerWidget {
  const VenueListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(venueFilterProvider);
    final venueList = ref.watch(venueListProvider);

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
                  isSelected: filter.sport == sport,
                  onToggle: (_) =>
                      ref.read(venueFilterProvider.notifier).setSport(sport),
                ),
              );
            }).toList(),
          ),
        ),

        // Venue list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(venueListProvider.future),
            child: AsyncValueWidget(
              value: venueList,
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                itemCount: 3,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 220),
                ),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(venueListProvider),
              ),
              data: (venues) {
                if (venues.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada lapangan ditemukan',
                    icon: Icons.search_off,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  itemCount: venues.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: VenueCard(venue: venues[i]),
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
