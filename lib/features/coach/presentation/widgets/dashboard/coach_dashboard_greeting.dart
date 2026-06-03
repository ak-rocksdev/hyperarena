import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/auth/providers/auth_provider.dart';
import 'package:hyperarena/features/coach/presentation/widgets/dashboard/coach_role_pill.dart';
import 'package:hyperarena/features/notification/presentation/widgets/notification_bell.dart';

class CoachDashboardGreeting extends ConsumerWidget {
  const CoachDashboardGreeting({super.key});

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            CoachRolePill(),
            NotificationBell(),
          ],
        ),
        const SizedBox(height: AppDimensions.md),
        Text(
          '${_greeting()}, ${Formatters.firstName(user?.name, fallback: 'Coach')}!',
          style: AppTypography.headingLarge,
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          'Kelola jadwal dan murid Anda',
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
