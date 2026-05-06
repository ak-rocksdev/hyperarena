import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_enums.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/utils/gamification_helpers.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late Set<Sport> _selectedSports;
  late Map<Sport, LevelTier> _selfAssessedLevels;

  final _picker = ImagePicker();
  bool _saving = false;
  bool _uploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider);

    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _bioController = TextEditingController(text: user?.bio ?? '');
    _cityController = TextEditingController(text: user?.city ?? '');
    _selectedSports = <Sport>{};
    _selfAssessedLevels = {};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _showDioError(DioException e, String fallback) {
    if (!mounted) return;
    final message =
        (e.response?.data as Map<String, dynamic>?)?['message'] as String? ??
            fallback;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  InputDecoration _fieldDecoration(String label) => InputDecoration(
        labelText: label,
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
      );

  Future<void> _handleSave() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final phone = _phoneController.text.trim();
      final response = await apiClient.put('/v1/auth/profile', data: {
        'name': _nameController.text.trim(),
        if (phone.isNotEmpty) 'phone': phone,
        // null clears the column on the BE; empty string would not.
        'bio': Formatters.nullIfEmpty(_bioController.text.trim()),
        'city': Formatters.nullIfEmpty(_cityController.text.trim()),
      });
      // Update auth state from PUT response (avoids extra GET /me call)
      final data = response.data as Map<String, dynamic>?;
      if (data != null && data.containsKey('user')) {
        ref.read(authNotifierProvider.notifier).updateFromResponse(
          data['user'] as Map<String, dynamic>,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } on DioException catch (e) {
      _showDioError(e, 'Gagal memperbarui profil');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _handleAvatarTap() {
    final hasAvatar = ref.read(authNotifierProvider)?.avatarUrl != null;
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUploadPhoto(ImageSource.gallery);
              },
            ),
            if (hasAvatar)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text('Hapus Foto',
                    style: TextStyle(color: AppColors.error)),
                onTap: () {
                  Navigator.pop(ctx);
                  _deletePhoto();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUploadPhoto(ImageSource source) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _uploadingPhoto = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(picked.path,
            filename: picked.name),
      });
      final response =
          await apiClient.post('/v1/auth/photo', data: formData);
      final data = response.data as Map<String, dynamic>?;
      if (data != null) {
        // Refresh the full user state so avatarUrl updates everywhere
        await ref.read(authNotifierProvider.notifier).refreshUser();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto berhasil diperbarui'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on DioException catch (e) {
      _showDioError(e, 'Gagal mengupload foto');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  Future<void> _deletePhoto() async {
    setState(() => _uploadingPhoto = true);
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.delete('/v1/auth/photo');
      await ref.read(authNotifierProvider.notifier).refreshUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foto berhasil dihapus'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } on DioException catch (e) {
      _showDioError(e, 'Gagal menghapus foto');
    } finally {
      if (mounted) setState(() => _uploadingPhoto = false);
    }
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
          _saving
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : TextButton(
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
        child: Builder(builder: (context) {
          final avatarUrl = ref.watch(authNotifierProvider)?.avatarUrl;
          return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: AppColors.primary100,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: _uploadingPhoto
                        ? const CircularProgressIndicator()
                        : avatarUrl == null
                            ? Icon(
                                Icons.person,
                                size: 56,
                                color: AppColors.primary,
                              )
                            : null,
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
              decoration: _fieldDecoration('Nama'),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _fieldDecoration('Nomor Telepon'),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _bioController,
              maxLines: 3,
              decoration: _fieldDecoration('Bio'),
              style: AppTypography.bodyMedium,
            ),
            SizedBox(height: AppDimensions.md),
            TextFormField(
              controller: _cityController,
              decoration: _fieldDecoration('Kota'),
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
                    decoration: _fieldDecoration(sport.name),
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
        );
        }),
      ),
    );
  }
}
