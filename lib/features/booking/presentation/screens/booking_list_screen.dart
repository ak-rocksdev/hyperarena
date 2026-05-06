import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/shared/widgets/feature_in_progress_view.dart';

/// Bookings screen — placeholder until backend `GET /v1/marketplace/me/bookings`
/// (Issue 14) ships. Replacing the mock list path with an honest "in progress"
/// view rather than displaying sample court bookings to the user.
class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Booking Saya'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Mendatang'),
              Tab(text: 'Selesai'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: const TabBarView(
          children: [
            _BookingsPendingView(
              tabLabel: 'Mendatang',
              description:
                  'Daftar sesi yang akan Anda ikuti akan muncul di sini setelah backend selesai disiapkan. Saat ini Anda dapat melihat sesi yang sudah Anda gabung melalui menu Explore.',
            ),
            _BookingsPendingView(
              tabLabel: 'Selesai',
              description:
                  'Riwayat sesi yang sudah Anda ikuti akan muncul di sini setelah backend selesai disiapkan.',
            ),
          ],
        ),
      ),
    );
  }
}

class _BookingsPendingView extends StatelessWidget {
  final String tabLabel;
  final String description;

  const _BookingsPendingView({
    required this.tabLabel,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.screenHorizontal,
            vertical: AppDimensions.sm,
          ),
          color: AppColors.warningLight,
          child: Row(
            children: [
              Icon(Icons.info_outline,
                  size: 16, color: AppColors.warningDark),
              const SizedBox(width: AppDimensions.sm),
              Expanded(
                child: Text(
                  'Backend untuk daftar booking sedang dalam pengembangan.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.warningDark,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: FeatureInProgressView(
            icon: Icons.event_note_outlined,
            title: 'Booking $tabLabel',
            description: description,
          ),
        ),
      ],
    );
  }
}
