import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/utils/formatters.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/picker_list_skeleton.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';

/// Opens the multi-select coach picker. The sheet loads the coach list itself
/// (shimmer / retry / empty states). Returns the new selection, or null if
/// dismissed.
Future<List<int>?> showCoachPicker(
  BuildContext context, {
  required List<int> selected,
}) {
  return showModalBottomSheet<List<int>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _CoachPickerSheet(initial: selected),
  );
}

class _CoachPickerSheet extends ConsumerStatefulWidget {
  const _CoachPickerSheet({required this.initial});

  final List<int> initial;

  @override
  ConsumerState<_CoachPickerSheet> createState() => _CoachPickerSheetState();
}

class _CoachPickerSheetState extends ConsumerState<_CoachPickerSheet> {
  late final Set<int> _selected = {...widget.initial};
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final coachesAsync = ref.watch(createSessionCoachesProvider);
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: AppDimensions.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimensions.lg,
                  AppDimensions.md, AppDimensions.lg, AppDimensions.sm),
              child: Row(
                children: [
                  Text('Pilih coach',
                      style: AppTypography.titleMedium
                          .copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Text('${_selected.length} dipilih',
                      style: AppTypography.caption
                          .copyWith(color: AppColors.textTertiary)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: 'Cari coach…',
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: coachesAsync.when(
                loading: () => const PickerListSkeleton(),
                error: (_, _) => ErrorView(
                  error: 'Gagal memuat daftar coach',
                  onRetry: () => ref.invalidate(createSessionCoachesProvider),
                ),
                data: (coaches) =>
                    _coachList(coaches, scrollController),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.lg),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pop(_selected.toList()),
                    child: Text('Pilih (${_selected.length})'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coachList(
    List<CoachOption> coaches,
    ScrollController scrollController,
  ) {
    if (coaches.isEmpty) {
      return const EmptyState(
        icon: Icons.sports_outlined,
        message: 'Belum ada coach di klub ini.\n'
            'Tambahkan coach dari panel admin dulu.',
      );
    }
    final filtered = coaches
        .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    if (filtered.isEmpty) {
      return EmptyState(
        icon: Icons.search_off_outlined,
        message: 'Tidak ada coach bernama "${_query.trim()}"',
      );
    }
    return ListView.builder(
      controller: scrollController,
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final c = filtered[i];
        final checked = _selected.contains(c.id);
        return CheckboxListTile(
          value: checked,
          onChanged: (_) => setState(() {
            checked ? _selected.remove(c.id) : _selected.add(c.id);
          }),
          controlAffinity: ListTileControlAffinity.leading,
          secondary: CircleAvatar(
            backgroundColor: AppColors.primary50,
            child: Text(
              c.name.isNotEmpty ? c.name.characters.first : '?',
              style: AppTypography.titleSmall
                  .copyWith(color: AppColors.primary900),
            ),
          ),
          title: Text(c.name, style: AppTypography.bodyMedium),
          subtitle: c.ratePerSession != null
              ? Text(
                  '${Formatters.formatCurrency(c.ratePerSession!, c.currency ?? 'IDR')} / sesi',
                  style: AppTypography.caption
                      .copyWith(color: AppColors.textTertiary),
                )
              : null,
        );
      },
    );
  }
}

/// Removable chips for the selected coaches (rendered by the host under the
/// picker field).
class SelectedCoachChips extends StatelessWidget {
  const SelectedCoachChips({
    super.key,
    required this.coaches,
    required this.selectedIds,
    required this.onRemove,
  });

  final List<CoachOption> coaches;
  final List<int> selectedIds;
  final ValueChanged<int> onRemove;

  @override
  Widget build(BuildContext context) {
    if (selectedIds.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppDimensions.xs,
      runSpacing: AppDimensions.xs,
      children: [
        for (final id in selectedIds)
          Chip(
            label: Text(
              coaches
                  .firstWhere(
                    (c) => c.id == id,
                    orElse: () => CoachOption(id: id, name: 'Coach #$id'),
                  )
                  .name,
            ),
            onDeleted: () => onRemove(id),
            deleteIcon: const Icon(Icons.close, size: 16),
            backgroundColor: AppColors.primary50,
            side: BorderSide(color: AppColors.primary200),
          ),
      ],
    );
  }
}
