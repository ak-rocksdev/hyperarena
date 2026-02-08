import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/mocks/mock_data.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late Set<Sport> _selectedSports;
  late Map<Sport, LevelTier> _selfAssessedLevels;

  LevelTier _parseTier(String? value) {
    if (value == null) return LevelTier.rookie;
    return LevelTier.values.firstWhere(
      (t) => t.name == value,
      orElse: () => LevelTier.rookie,
    );
  }

  @override
  void initState() {
    super.initState();
    final user = MockData.currentUser;
    final profile = MockData.currentProfile;

    _nameController = TextEditingController(text: user.name);
    _bioController = TextEditingController(text: profile.bio);
    _cityController = TextEditingController(text: profile.city);
    _selectedSports = Set.from(profile.sports);
    _selfAssessedLevels = {
      for (final entry in profile.selfAssessedLevels.entries)
        Sport.values.firstWhere(
          (s) => s.name == entry.key,
          orElse: () => Sport.tennis,
        ): _parseTier(entry.value),
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _handleSave() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profil berhasil diperbarui'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  void _handleAvatarTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Fitur upload foto akan tersedia segera'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: Text('Edit Profil'),
        backgroundColor: AppSurfaces.surface,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _handleSave,
            child: Text(
              'Simpan',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.screenHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: AppColors.primary100,
                    child: Icon(
                      Icons.person,
                      size: 56,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _handleAvatarTap,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: AppShadows.sm,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.xl),
            Text(
              'Informasi Dasar',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _nameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Nama',
                filled: true,
                fillColor: AppColors.neutral100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide.none,
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Bio',
                filled: true,
                fillColor: AppSurfaces.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide(color: AppColors.neutral200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide(color: AppColors.neutral200),
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Kota',
                filled: true,
                fillColor: AppSurfaces.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide(color: AppColors.neutral200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  borderSide: BorderSide(color: AppColors.neutral200),
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.xl),
            Text(
              'Olahraga yang Diminati',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppDimensions.md),
            Wrap(
              spacing: AppDimensions.sm,
              runSpacing: AppDimensions.sm,
              children: Sport.values.map((sport) {
                final isSelected = _selectedSports.contains(sport);
                return FilterChip(
                  label: Text(sport.name),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedSports.add(sport);
                        if (!_selfAssessedLevels.containsKey(sport)) {
                          _selfAssessedLevels[sport] = LevelTier.rookie;
                        }
                      } else {
                        _selectedSports.remove(sport);
                        _selfAssessedLevels.remove(sport);
                      }
                    });
                  },
                  selectedColor: AppColors.primary100,
                  checkmarkColor: AppColors.primary,
                  labelStyle: AppTypography.bodySmall.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                );
              }).toList(),
            ),
            if (_selectedSports.isNotEmpty) ...[
              SizedBox(height: AppDimensions.xl),
              Text(
                'Level Kemampuan',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimensions.md),
              ..._selectedSports.map((sport) {
                return Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.md),
                  child: DropdownButtonFormField<LevelTier>(
                    initialValue: _selfAssessedLevels[sport] ?? LevelTier.rookie,
                    decoration: InputDecoration(
                      labelText: sport.name,
                      filled: true,
                      fillColor: AppSurfaces.surface,
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        borderSide: BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusMd),
                        borderSide: BorderSide(color: AppColors.neutral200),
                      ),
                    ),
                    items: LevelTier.values.map((tier) {
                      return DropdownMenuItem(
                        value: tier,
                        child: Text(
                          GamificationHelpers.tierLabel(tier),
                          style: AppTypography.bodyMedium,
                        ),
                      );
                    }).toList(),
                    onChanged: (tier) {
                      if (tier != null) {
                        setState(() {
                          _selfAssessedLevels[sport] = tier;
                        });
                      }
                    },
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }
}
