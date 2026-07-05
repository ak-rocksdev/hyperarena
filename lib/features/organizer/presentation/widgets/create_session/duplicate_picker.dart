import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/session_type_cards.dart';

/// The "Salin dari sesi terakhir?" accelerator. Shows a tappable prompt (or,
/// once a source is applied, a dismissible banner). Opens a sheet of recent
/// sessions and reports the chosen id.
class DuplicatePicker extends StatelessWidget {
  const DuplicatePicker({
    super.key,
    required this.recent,
    required this.onPicked,
    this.appliedLabel,
    this.onClear,
  });

  final List<RecentSessionOption> recent;
  final ValueChanged<String> onPicked;

  /// When non-null, a duplicate source is active — show the banner instead.
  final String? appliedLabel;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    if (appliedLabel != null) {
      return Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Row(
          children: [
            const Icon(Icons.content_copy, size: 18, color: AppColors.primary),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text('Disalin dari $appliedLabel',
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.primary900)),
            ),
            GestureDetector(
              onTap: onClear,
              child: Text('Reset',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  )),
            ),
          ],
        ),
      );
    }

    if (recent.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () async {
        final id = await _showRecentPicker(context, recent);
        if (id != null) onPicked(id);
      },
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.base),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
          border: Border.all(color: AppColors.neutral200),
        ),
        child: Row(
          children: [
            const Icon(Icons.content_copy_outlined,
                size: 18, color: AppColors.textSecondary),
            const SizedBox(width: AppDimensions.sm),
            Expanded(
              child: Text('Salin dari sesi terakhir?',
                  style: AppTypography.bodyMedium
                      .copyWith(color: AppColors.textSecondary)),
            ),
            const Icon(Icons.chevron_right, color: AppColors.neutral500),
          ],
        ),
      ),
    );
  }
}

Future<String?> _showRecentPicker(
  BuildContext context,
  List<RecentSessionOption> recent,
) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: AppDimensions.md),
          Text('Sesi terbaru',
              style:
                  AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppDimensions.sm),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: recent.length,
              itemBuilder: (_, i) {
                final r = recent[i];
                return ListTile(
                  title: Text(Formatters.formatDateTimeCompact(r.startAt),
                      style: AppTypography.bodyMedium),
                  subtitle: Text(
                    '${r.type.label} · ${r.coachName ?? '—'} · ${r.venueName ?? '—'}',
                    style: AppTypography.caption
                        .copyWith(color: AppColors.neutral500),
                  ),
                  onTap: () => Navigator.of(context).pop(r.id),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
