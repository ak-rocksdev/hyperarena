import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';

/// Opens the venue picker: search + select an existing active venue, or add a
/// new one inline. Returns the chosen [VenueOption], or null if dismissed.
Future<VenueOption?> showVenuePicker(
  BuildContext context, {
  required List<VenueOption> venues,
  String? selectedId,
}) {
  return showModalBottomSheet<VenueOption>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _VenuePickerSheet(venues: venues, selectedId: selectedId),
  );
}

class _VenuePickerSheet extends StatefulWidget {
  const _VenuePickerSheet({required this.venues, this.selectedId});

  final List<VenueOption> venues;
  final String? selectedId;

  @override
  State<_VenuePickerSheet> createState() => _VenuePickerSheetState();
}

class _VenuePickerSheetState extends State<_VenuePickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.trim();
    final filtered = widget.venues
        .where((v) => v.name.toLowerCase().contains(q.toLowerCase()))
        .toList();
    final showCreate = q.isNotEmpty &&
        !widget.venues.any((v) => v.name.toLowerCase() == q.toLowerCase());

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Pilih venue',
                    style: AppTypography.titleMedium
                        .copyWith(fontWeight: FontWeight.w700)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  isDense: true,
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: 'Cari atau ketik venue baru…',
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: ListView(
                controller: scrollController,
                children: [
                  if (showCreate)
                    ListTile(
                      leading: const Icon(Icons.add_location_alt_outlined,
                          color: AppColors.primary),
                      title: Text('Buat venue "$q"',
                          style: AppTypography.bodyMedium
                              .copyWith(color: AppColors.primary900)),
                      onTap: () => Navigator.of(context).pop(
                        VenueOption(id: 'new:$q', name: q),
                      ),
                    ),
                  for (final v in filtered)
                    ListTile(
                      leading: const Icon(Icons.place_outlined),
                      title: Text(v.name, style: AppTypography.bodyMedium),
                      subtitle: v.city != null
                          ? Text(v.city!,
                              style: AppTypography.caption
                                  .copyWith(color: AppColors.textTertiary))
                          : null,
                      trailing: v.id == widget.selectedId
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () => Navigator.of(context).pop(v),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
