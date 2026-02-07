import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/core/widgets/shimmer_loading.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/session/presentation/widgets/session_card.dart';
import 'package:hyperarena/features/session/providers/session_providers.dart';

class SessionListScreen extends ConsumerWidget {
  const SessionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(sessionFilterProvider);
    final sessionList = ref.watch(sessionListProvider);

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
                      ref.read(sessionFilterProvider.notifier).setSport(sport),
                ),
              );
            }).toList(),
          ),
        ),

        // Session list
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => ref.refresh(sessionListProvider.future),
            child: AsyncValueWidget(
              value: sessionList,
              loading: () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.screenHorizontal,
                ),
                itemCount: 3,
                itemBuilder: (_, _) => Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.md),
                  child: ShimmerLoading.card(height: 200),
                ),
              ),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(sessionListProvider),
              ),
              data: (sessions) {
                if (sessions.isEmpty) {
                  return const EmptyState(
                    message: 'Tidak ada sesi terbuka',
                    icon: Icons.groups_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.screenHorizontal,
                  ),
                  itemCount: sessions.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimensions.md),
                    child: SessionCard(session: sessions[i]),
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
