import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _sessionReminders = true;
  bool _paymentReminders = true;
  bool _reviewReminders = true;

  void _showPlaceholderSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Akun',
          style: AppTypography.titleMedium,
        ),
        content: Text(
          'Tindakan ini tidak dapat dibatalkan. Semua data Anda akan dihapus secara permanen.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Batal',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showPlaceholderSnackbar('Fitur hapus akun akan tersedia segera');
            },
            child: Text(
              'Hapus',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral50,
      appBar: AppBar(
        title: Text('Pengaturan'),
        backgroundColor: AppSurfaces.surface,
        elevation: 0,
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Notifikasi'),
          Container(
            color: AppSurfaces.surface,
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(
                    'Pengingat Sesi',
                    style: AppTypography.bodyMedium,
                  ),
                  value: _sessionReminders,
                  onChanged: (value) {
                    setState(() {
                      _sessionReminders = value;
                    });
                  },
                  activeTrackColor: AppColors.primary,
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: Text(
                    'Pengingat Pembayaran',
                    style: AppTypography.bodyMedium,
                  ),
                  value: _paymentReminders,
                  onChanged: (value) {
                    setState(() {
                      _paymentReminders = value;
                    });
                  },
                  activeTrackColor: AppColors.primary,
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                SwitchListTile(
                  title: Text(
                    'Ulasan & Penilaian',
                    style: AppTypography.bodyMedium,
                  ),
                  value: _reviewReminders,
                  onChanged: (value) {
                    setState(() {
                      _reviewReminders = value;
                    });
                  },
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.base),
          _buildSectionHeader('Privasi'),
          Container(
            color: AppSurfaces.surface,
            child: ListTile(
              title: Text(
                'Visibilitas Profil',
                style: AppTypography.bodyMedium,
              ),
              subtitle: Text(
                'Publik',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
              onTap: () => _showPlaceholderSnackbar(
                  'Fitur pengaturan privasi akan tersedia segera'),
            ),
          ),
          SizedBox(height: AppDimensions.base),
          _buildSectionHeader('Akun'),
          Container(
            color: AppSurfaces.surface,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Ganti Password',
                    style: AppTypography.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                  onTap: () => _showPlaceholderSnackbar(
                      'Fitur ganti password akan tersedia segera'),
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(
                    'Hapus Akun',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.error,
                  ),
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.base),
          _buildSectionHeader('Tentang'),
          Container(
            color: AppSurfaces.surface,
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    'Versi Aplikasi',
                    style: AppTypography.bodyMedium,
                  ),
                  subtitle: Text(
                    '1.0.0 (Mock)',
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Divider(height: 1, indent: 16, endIndent: 16),
                ListTile(
                  title: Text(
                    'Kebijakan Privasi',
                    style: AppTypography.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                  ),
                  onTap: () => _showPlaceholderSnackbar(
                      'Fitur kebijakan privasi akan tersedia segera'),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.xl),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenHorizontal,
        AppDimensions.base,
        AppDimensions.screenHorizontal,
        AppDimensions.sm,
      ),
      child: Text(
        title,
        style: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
