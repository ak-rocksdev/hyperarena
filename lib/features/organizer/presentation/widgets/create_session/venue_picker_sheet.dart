import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/core/widgets/error_view.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/create_session/picker_list_skeleton.dart';
import 'package:hyperarena/features/organizer/providers/create_session_provider.dart';

/// Opens the venue picker: search + select an existing active venue, or add a
/// new one inline. The sheet loads the venue list itself (shimmer / retry /
/// empty states). Returns the chosen [VenueOption], or null if dismissed.
Future<VenueOption?> showVenuePicker(
  BuildContext context, {
  String? selectedId,
}) {
  return showModalBottomSheet<VenueOption>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _VenuePickerSheet(selectedId: selectedId),
  );
}

class _VenuePickerSheet extends ConsumerStatefulWidget {
  const _VenuePickerSheet({this.selectedId});

  final String? selectedId;

  @override
  ConsumerState<_VenuePickerSheet> createState() => _VenuePickerSheetState();
}

class _VenuePickerSheetState extends ConsumerState<_VenuePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final venuesAsync = ref.watch(createSessionVenuesProvider);
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
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.lg,
                AppDimensions.md,
                AppDimensions.lg,
                AppDimensions.sm,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih venue',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: 'Cari venue tersimpan atau tempat baru…',
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: venuesAsync.when(
                loading: () => const PickerListSkeleton(),
                error: (_, _) => ErrorView(
                  error: 'Gagal memuat daftar venue',
                  onRetry: () => ref.invalidate(createSessionVenuesProvider),
                ),
                data: (venues) => _venueList(venues, scrollController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _venueList(
    List<VenueOption> venues,
    ScrollController scrollController,
  ) {
    final q = _query.trim();
    final filtered = venues
        .where((v) => v.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final showCreate =
        q.isNotEmpty &&
        !venues.any((v) => v.name.toLowerCase() == q.toLowerCase());

    if (venues.isEmpty && q.isEmpty) {
      return const EmptyState(
        icon: Icons.place_outlined,
        message:
            'Belum ada venue tersimpan.\n'
            'Ketik nama tempat untuk cari di Google Maps.',
      );
    }
    return ListView(
      controller: scrollController,
      children: [
        if (showCreate)
          ListTile(
            leading: const Icon(Icons.travel_explore, color: AppColors.primary),
            title: Text(
              'Cari "$q" di Google Maps',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary900,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Pilih lokasi di peta, lalu simpan jadi venue',
              style: AppTypography.caption.copyWith(
                color: AppColors.neutral500,
              ),
            ),
            trailing: const Icon(
              Icons.chevron_right,
              color: AppColors.neutral500,
            ),
            onTap: () =>
                Navigator.of(context).pop(VenueOption(id: 'new:$q', name: q)),
          ),
        for (final v in filtered)
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(v.name, style: AppTypography.bodyMedium),
            subtitle: v.city != null
                ? Text(
                    v.city!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutral500,
                    ),
                  )
                : null,
            trailing: v.id == widget.selectedId
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () => Navigator.of(context).pop(v),
          ),
      ],
    );
  }
}
