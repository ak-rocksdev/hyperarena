import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';

/// Footer tile shown when a paginated `loadMore` page fails. Renders an
/// icon + short copy + "Coba lagi" button so the next swipe doesn't just
/// silently re-fire the same failing request.
class LoadMoreErrorTile extends StatelessWidget {
  final VoidCallback onRetry;

  const LoadMoreErrorTile({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.base),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            size: 18,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: AppDimensions.sm),
          const Expanded(
            child: Text(
              'Gagal memuat lebih banyak',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}
