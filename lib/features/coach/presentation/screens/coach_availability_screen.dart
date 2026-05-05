import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class CoachAvailabilityScreen extends StatelessWidget {
  const CoachAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketersediaan', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.all(AppDimensions.screenHorizontal),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 64,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(height: AppDimensions.base),
                Text(
                  'Penjadwalan diatur oleh admin',
                  style: AppTypography.headingSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.sm),
                Text(
                  'Penjadwalan diatur langsung oleh admin sekolahmu. '
                  'Hubungi admin untuk mengatur ketersediaan dan jadwal sesimu.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
