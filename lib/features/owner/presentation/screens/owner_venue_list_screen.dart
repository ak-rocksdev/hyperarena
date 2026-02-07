import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

class OwnerVenueListScreen extends StatelessWidget {
  const OwnerVenueListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Saya')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.screenHorizontal),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined, size: 64, color: AppColors.neutral400),
              const SizedBox(height: AppDimensions.base),
              Text('Segera hadir', style: AppTypography.headingSmall),
              const SizedBox(height: AppDimensions.xs),
              Text(
                'Fitur manajemen venue sedang dalam pengembangan.',
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
