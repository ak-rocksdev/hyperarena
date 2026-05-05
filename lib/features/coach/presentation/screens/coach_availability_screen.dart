import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/shared/widgets/feature_in_progress_view.dart';

class CoachAvailabilityScreen extends StatelessWidget {
  const CoachAvailabilityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketersediaan', style: AppTypography.titleMedium),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: FeatureInProgressView(
          icon: Icons.event_available,
          title: 'Pengaturan ketersediaan belum aktif',
          description:
              'Backend untuk menyimpan jadwal ketersediaan coach sedang '
              'dalam pengembangan. Anda akan diberi tahu saat fitur ini siap.',
        ),
      ),
    );
  }
}
