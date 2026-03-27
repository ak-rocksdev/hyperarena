import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_list_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_list_screen.dart';
import 'package:hyperarena/features/venue/presentation/screens/venue_list_screen.dart';
import 'package:hyperarena/shared/providers/app_config_provider.dart';
import 'package:hyperarena/shared/providers/marketplace_providers.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final useMock = ref.watch(appConfigProvider).useMockData;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lapangan'),
              Tab(text: 'Coach'),
              Tab(text: 'Sesi'),
            ],
          ),
        ),
        body: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    setState(() => _searchQuery = v.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Cari venue, coach, atau sesi...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.md,
                    vertical: AppDimensions.sm,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                    borderSide: const BorderSide(color: AppColors.neutral200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusFull),
                    borderSide: const BorderSide(color: AppColors.neutral200),
                  ),
                  filled: true,
                  fillColor: AppColors.neutral50,
                ),
              ),
            ),

            // Sport filter chips (API mode only — mock mode chips live in sub-screens)
            if (!useMock) _buildApiSportChips(),

            // Tab views
            Expanded(
              child: TabBarView(
                children: [
                  VenueListScreen(searchQuery: _searchQuery),
                  CoachListScreen(searchQuery: _searchQuery),
                  SessionListScreen(searchQuery: _searchQuery),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiSportChips() {
    final sportsAsync = ref.watch(sportFiltersProvider);
    final selectedId = ref.watch(selectedSportIdProvider);

    return SizedBox(
      height: AppDimensions.chipHeight + AppDimensions.base,
      child: sportsAsync.when(
        loading: () => const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, _) => const SizedBox.shrink(),
        data: (sports) => ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontal,
            vertical: AppDimensions.sm,
          ),
          children: [
            // "All" chip
            Padding(
              padding: const EdgeInsets.only(right: AppDimensions.sm),
              child: FilterChip(
                selected: selectedId == null,
                label: const Text('Semua'),
                onSelected: (_) =>
                    ref.read(selectedSportIdProvider.notifier).state = null,
              ),
            ),
            // Dynamic sport chips
            ...sports.map((sport) => Padding(
                  padding: const EdgeInsets.only(right: AppDimensions.sm),
                  child: FilterChip(
                    selected: selectedId == sport.id,
                    label: Text(sport.name),
                    onSelected: (_) => ref
                        .read(selectedSportIdProvider.notifier)
                        .state = sport.id,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
