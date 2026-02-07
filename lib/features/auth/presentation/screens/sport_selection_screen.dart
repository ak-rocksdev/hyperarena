import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/app_button.dart';
import 'package:hyperarena/features/auth/presentation/widgets/sport_chip_selector.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/routing/app_routes.dart';

class SportSelectionScreen extends ConsumerStatefulWidget {
  const SportSelectionScreen({super.key});

  @override
  ConsumerState<SportSelectionScreen> createState() =>
      _SportSelectionScreenState();
}

class _SportSelectionScreenState extends ConsumerState<SportSelectionScreen> {
  final Set<Sport> _selectedSports = {};
  final Map<Sport, LevelTier> _levels = {};

  @override
  Widget build(BuildContext context) {
    final hasSelection = _selectedSports.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Olahraga'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Olahraga Favorit',
                      style: AppTypography.headingLarge,
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      'Kamu bisa memilih lebih dari satu',
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xl),

                    // Sport chips grid
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimensions.base),
                      decoration: BoxDecoration(
                        color: AppSurfaces.surface,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        boxShadow: AppShadows.sm,
                      ),
                      child: Wrap(
                        spacing: AppDimensions.sm,
                        runSpacing: AppDimensions.sm,
                        children: Sport.values.map((sport) {
                          final isSelected = _selectedSports.contains(sport);
                          return SportChipSelector(
                            sport: sport,
                            isSelected: isSelected,
                            onToggle: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedSports.add(sport);
                                  _levels[sport] = LevelTier.rookie;
                                } else {
                                  _selectedSports.remove(sport);
                                  _levels.remove(sport);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),

                    // Level dropdowns for selected sports
                    if (_selectedSports.isNotEmpty) ...[
                      const SizedBox(height: AppDimensions.xl),
                      Text(
                        'Tingkat Kemampuan',
                        style: AppTypography.titleMedium,
                      ),
                      const SizedBox(height: AppDimensions.md),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimensions.base),
                        decoration: BoxDecoration(
                          color: AppSurfaces.surfaceHighlight,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                        ),
                        child: Column(
                          children: [
                            ...(_selectedSports.toList()..sort((a, b) => a.index.compareTo(b.index))).map((sport) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: AppDimensions.md),
                                child: Row(
                                  children: [
                                    Icon(
                                      SportChipSelector.sportIcon(sport),
                                      size: 20,
                                    ),
                                    const SizedBox(width: AppDimensions.sm),
                                    Expanded(
                                      child: Text(
                                        SportChipSelector.sportLabel(sport),
                                        style: AppTypography.bodyMedium,
                                      ),
                                    ),
                                    DropdownButton<LevelTier>(
                                      value: _levels[sport] ?? LevelTier.rookie,
                                      underline: const SizedBox.shrink(),
                                      items: LevelTier.values.map((tier) {
                                        return DropdownMenuItem(
                                          value: tier,
                                          child: Text(_tierLabel(tier)),
                                        );
                                      }).toList(),
                                      onChanged: (tier) {
                                        if (tier != null) {
                                          setState(() => _levels[sport] = tier);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Bottom button
            Padding(
              padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  boxShadow: hasSelection ? AppShadows.colored : null,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'Lanjutkan',
                    isLarge: true,
                    onPressed: hasSelection
                        ? () {
                            final role = ref.read(authNotifierProvider)?.role ?? UserRole.player;
                            context.go(AppRoutes.home(role));
                          }
                        : null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _tierLabel(LevelTier tier) => switch (tier) {
        LevelTier.rookie => 'Pemula',
        LevelTier.amateur => 'Amatir',
        LevelTier.intermediate => 'Menengah',
        LevelTier.advanced => 'Mahir',
        LevelTier.pro => 'Profesional',
      };
}
