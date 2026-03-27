import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Shows a modal bottom sheet asking the user to confirm using a credit
/// to join a session. Returns `true` if the user taps "Gabung".
Future<bool?> showCreditConfirmationSheet({
  required BuildContext context,
  required int creditBalance,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusLg),
      ),
    ),
    builder: (_) => _CreditConfirmationContent(creditBalance: creditBalance),
  );
}

class _CreditConfirmationContent extends StatelessWidget {
  final int creditBalance;

  const _CreditConfirmationContent({required this.creditBalance});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.screenHorizontal,
          AppDimensions.lg,
          AppDimensions.screenHorizontal,
          AppDimensions.screenBottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.neutral300,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.lg),

            // Title
            Text('Gunakan Kredit?', style: AppTypography.headingSmall),
            const SizedBox(height: AppDimensions.md),

            // Body
            RichText(
              text: TextSpan(
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: 'Kamu punya '),
                  TextSpan(
                    text: '$creditBalance kredit',
                    style: AppTypography.titleSmall,
                  ),
                  const TextSpan(
                    text:
                        ' tersedia. 1 kredit akan digunakan untuk bergabung di sesi ini. Tidak perlu melakukan pembayaran.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.sm),

            // Subtitle
            Text(
              'Kredit bisa dikembalikan jika sesi dibatalkan oleh penyelenggara.',
              style: AppTypography.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.xl),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      minimumSize:
                          const Size.fromHeight(AppDimensions.buttonHeightMd),
                    ),
                    child: const Text('Batal'),
                  ),
                ),
                const SizedBox(width: AppDimensions.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      minimumSize:
                          const Size.fromHeight(AppDimensions.buttonHeightMd),
                    ),
                    child: const Text('Gabung'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
