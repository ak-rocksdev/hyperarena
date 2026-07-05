import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Shown when the tenant hasn't configured payout/bank details — a precondition
/// for creating any session. Returns `true` if the user chose to go to
/// settings (the caller performs the navigation).
Future<bool> showPaymentGuard(BuildContext context) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_outlined,
                  color: AppColors.warningDark),
            ),
            const SizedBox(height: AppDimensions.md),
            Text('Atur rekening pencairan dulu',
                style: AppTypography.titleMedium
                    .copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: AppDimensions.xs),
            Text(
              'Sesi membutuhkan informasi bank untuk pencairan dana. '
              'Lengkapi rekening di pengaturan sebelum membuat sesi.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppDimensions.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ke Pengaturan'),
            ),
            const SizedBox(height: AppDimensions.xs),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Nanti'),
            ),
          ],
        ),
      ),
    ),
  );
  return result ?? false;
}
