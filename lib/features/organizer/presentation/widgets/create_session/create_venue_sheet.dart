import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:hyperarena/features/organizer/data/models/session_lookup_options.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';

/// Create-venue flow with Google Places accuracy: search a place (via the BE
/// proxy) → confirm/nudge the pin on a map → save. Returns the persisted
/// [VenueOption] (real numeric id), or null if dismissed.
Future<VenueOption?> showCreateVenueSheet(
  BuildContext context, {
  String? initialQuery,
}) {
  return showModalBottomSheet<VenueOption>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppSurfaces.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _CreateVenueSheet(initialQuery: initialQuery),
  );
}

class _CreateVenueSheet extends ConsumerStatefulWidget {
  const _CreateVenueSheet({this.initialQuery});

  final String? initialQuery;

  @override
  ConsumerState<_CreateVenueSheet> createState() => _CreateVenueSheetState();
}

class _CreateVenueSheetState extends ConsumerState<_CreateVenueSheet> {
  // Groups this sheet's autocomplete keystrokes + details call into one
  // billable Places session.
  late final String _sessionToken = DateTime.now().microsecondsSinceEpoch
      .toString();

  late final TextEditingController _searchCtrl = TextEditingController(
    text: widget.initialQuery ?? '',
  );
  final _nameCtrl = TextEditingController();

  Timer? _debounce;
  List<PlacePrediction> _predictions = [];
  bool _searching = false;

  // Fallback pin for a manual venue (no Google match): central Jakarta. The
  // user drags it to the real spot.
  static const LatLng _defaultCenter = LatLng(-6.2088, 106.8456);

  PlaceDetails? _selected;
  LatLng? _pos;
  // True once the user chose "buat manual": confirm view runs with no Google
  // place — just a name + a pin they place themselves.
  bool _manual = false;
  bool _resolving = false;
  bool _saving = false;
  String? _error;

  // Manual-mode "jump the map to an area" search: recenters camera + pin so the
  // user starts near the target instead of dragging across the city. The venue
  // stays custom — this only repositions, it doesn't attach a Google place.
  GoogleMapController? _mapController;
  final _areaCtrl = TextEditingController();
  Timer? _areaDebounce;
  List<PlacePrediction> _areaResults = [];
  bool _areaSearching = false;

  @override
  void initState() {
    super.initState();
    final initial = (widget.initialQuery ?? '').trim();
    if (initial.isNotEmpty) {
      // _runSearch calls setState — illegal during the first build, so defer
      // it a frame. This is the primary entry path (opened with the typed name).
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _runSearch(initial);
      });
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _areaDebounce?.cancel();
    _searchCtrl.dispose();
    _nameCtrl.dispose();
    _areaCtrl.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(value.trim());
    });
  }

  Future<void> _runSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _predictions = [];
        _error = null;
      });
      return;
    }
    setState(() {
      _searching = true;
      _error = null;
    });
    try {
      final results = await ref
          .read(organizerRepositoryProvider)
          .placesAutocomplete(query, _sessionToken);
      // Drop a slow response the user has already typed past.
      if (!mounted || query != _searchCtrl.text.trim()) return;
      setState(() => _predictions = results);
    } catch (_) {
      if (!mounted || query != _searchCtrl.text.trim()) return;
      setState(() => _predictions = []);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _pickPrediction(PlacePrediction p) async {
    FocusScope.of(context).unfocus();
    setState(() => _resolving = true);
    try {
      final details = await ref
          .read(organizerRepositoryProvider)
          .placeDetails(p.placeId, _sessionToken);
      if (!mounted) return;
      if (details == null || details.lat == null || details.lng == null) {
        setState(() => _error = 'Lokasi tidak bisa dimuat. Coba pilih lain.');
        return;
      }
      setState(() {
        _selected = details;
        _pos = LatLng(details.lat!, details.lng!);
        _nameCtrl.text = details.name.isNotEmpty ? details.name : p.mainText;
        _error = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Gagal memuat detail lokasi.');
    } finally {
      if (mounted) setState(() => _resolving = false);
    }
  }

  /// Switch to the confirm view for a custom venue Google doesn't know. No
  /// place_id/address — just a name the user typed and a pin they'll place.
  void _startManual() {
    FocusScope.of(context).unfocus();
    final q = _searchCtrl.text.trim();
    setState(() {
      _manual = true;
      _selected = null;
      _pos = _defaultCenter;
      _error = null;
      if (_nameCtrl.text.trim().isEmpty) _nameCtrl.text = q;
    });
  }

  void _onAreaChanged(String value) {
    _areaDebounce?.cancel();
    _areaDebounce = Timer(const Duration(milliseconds: 350), () {
      _areaSearch(value.trim());
    });
  }

  Future<void> _areaSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _areaResults = []);
      return;
    }
    setState(() => _areaSearching = true);
    try {
      final results = await ref
          .read(organizerRepositoryProvider)
          .placesAutocomplete(query, _sessionToken);
      if (!mounted || query != _areaCtrl.text.trim()) return;
      setState(() => _areaResults = results);
    } catch (_) {
      if (!mounted || query != _areaCtrl.text.trim()) return;
      setState(() => _areaResults = []);
    } finally {
      if (mounted) setState(() => _areaSearching = false);
    }
  }

  /// Recenter the map + pin on the chosen area. Keeps the venue custom — this
  /// is navigation only, so name/place_id are untouched; the user still nudges
  /// the pin to the exact spot afterwards.
  Future<void> _pickArea(PlacePrediction p) async {
    FocusScope.of(context).unfocus();
    _areaCtrl.text = p.mainText;
    setState(() => _areaResults = []);
    try {
      final details = await ref
          .read(organizerRepositoryProvider)
          .placeDetails(p.placeId, _sessionToken);
      if (!mounted || details?.lat == null || details?.lng == null) return;
      final target = LatLng(details!.lat!, details.lng!);
      setState(() => _pos = target);
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, 16),
      );
    } catch (_) {
      // Best-effort recenter; a failure just leaves the map where it was.
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    // Place fields are optional (manual venue) — only name + a pin are required.
    if (name.isEmpty || _pos == null) return;
    setState(() => _saving = true);
    try {
      final venue = await ref
          .read(organizerRepositoryProvider)
          .createVenue(
            name: name,
            googlePlaceId: _selected?.googlePlaceId,
            address: _selected?.address,
            lat: _pos!.latitude,
            lng: _pos!.longitude,
          );
      if (!mounted) return;
      Navigator.of(context).pop(venue);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _error = 'Gagal menyimpan venue. Coba lagi.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
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
              child: Row(
                children: [
                  Text(
                    'Buat venue',
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
            ),
            // Search only belongs to the pick step; in confirm mode (Google or
            // manual) the map + name are the focus, so hide the field.
            if (_selected == null && !_manual)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.lg,
                ),
                child: TextField(
                  controller: _searchCtrl,
                  autofocus: true,
                  onChanged: _onQueryChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searching
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                    hintText: 'Cari nama tempat atau alamat…',
                  ),
                ),
              ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.lg,
                  AppDimensions.sm,
                  AppDimensions.lg,
                  0,
                ),
                child: Text(
                  _error!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.errorDark,
                  ),
                ),
              ),
            const SizedBox(height: AppDimensions.sm),
            Expanded(
              child: _resolving
                  ? const Center(child: CircularProgressIndicator())
                  : (_selected != null || _manual)
                  ? _confirmView(scrollController)
                  : _predictionList(scrollController),
            ),
          ],
        ),
      ),
    );
  }

  Widget _predictionList(ScrollController controller) {
    final hasQuery = _searchCtrl.text.trim().isNotEmpty;

    if (_predictions.isEmpty) {
      // Empty query → just prompt. Query with no Google match → offer the
      // manual escape hatch so a venue Google doesn't know is never a dead end.
      return ListView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        children: [
          const SizedBox(height: AppDimensions.xl),
          Icon(
            hasQuery ? Icons.search_off : Icons.search,
            size: AppDimensions.iconXl,
            color: AppColors.neutral400,
          ),
          const SizedBox(height: AppDimensions.sm),
          Text(
            hasQuery
                ? 'Tidak ada di Google Maps.'
                : 'Ketik untuk mencari lokasi dari Google Maps.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.neutral500,
            ),
          ),
          if (hasQuery) ...[
            const SizedBox(height: AppDimensions.md),
            _manualTile(),
          ],
        ],
      );
    }
    return ListView(
      controller: controller,
      children: [
        for (final p in _predictions)
          ListTile(
            leading: const Icon(Icons.place_outlined, color: AppColors.primary),
            title: Text(p.mainText, style: AppTypography.bodyMedium),
            subtitle: p.secondaryText != null
                ? Text(
                    p.secondaryText!,
                    style: AppTypography.caption.copyWith(
                      color: AppColors.neutral500,
                    ),
                  )
                : null,
            onTap: _resolving ? null : () => _pickPrediction(p),
          ),
        const Divider(height: 1),
        // Even when Google has matches, the exact court may not be listed.
        _manualTile(),
      ],
    );
  }

  /// Entry to the manual-venue path — used both as the no-results action and a
  /// footer under Google results.
  Widget _manualTile() {
    return ListTile(
      leading: const Icon(
        Icons.edit_location_alt_outlined,
        color: AppColors.primary,
      ),
      title: Text(
        'Tandai lokasi sendiri di peta',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.primary900,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'Untuk venue yang tidak ada di Google Maps',
        style: AppTypography.caption.copyWith(color: AppColors.neutral500),
      ),
      onTap: _startManual,
    );
  }

  Widget _confirmView(ScrollController controller) {
    final pos = _pos!;
    return ListView(
      controller: controller,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.lg,
        0,
        AppDimensions.lg,
        AppDimensions.lg,
      ),
      children: [
        Text(
          _manual
              ? 'Cari area lalu ketuk/geser pin ke titik yang tepat.'
              : 'Geser pin untuk menepatkan lokasi.',
          style: AppTypography.caption.copyWith(color: AppColors.neutral500),
        ),
        const SizedBox(height: AppDimensions.sm),
        if (_manual) ...[
          TextField(
            controller: _areaCtrl,
            onChanged: _onAreaChanged,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _areaSearching
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : (_areaCtrl.text.isNotEmpty
                        ? IconButton(
                            visualDensity: VisualDensity.compact,
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              _areaCtrl.clear();
                              setState(() => _areaResults = []);
                            },
                          )
                        : null),
              hintText: 'Cari area atau jalan untuk pindah peta…',
            ),
          ),
          for (final p in _areaResults)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.place_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              title: Text(
                p.mainText,
                style: AppTypography.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: p.secondaryText != null
                  ? Text(
                      p.secondaryText!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.neutral500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              onTap: () => _pickArea(p),
            ),
          const SizedBox(height: AppDimensions.sm),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              onMapCreated: (c) => _mapController = c,
              initialCameraPosition: CameraPosition(
                target: pos,
                zoom: _manual ? 13 : 16,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('venue'),
                  position: pos,
                  draggable: true,
                  onDragEnd: (p) => setState(() => _pos = p),
                ),
              },
              onTap: (p) => setState(() => _pos = p),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
          ),
        ),
        if (_selected?.address != null) ...[
          const SizedBox(height: AppDimensions.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.neutral500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _selected!.address!,
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (_selected == null && _manual) ...[
          const SizedBox(height: AppDimensions.sm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppColors.neutral500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Lokasi kustom — tandai titik yang tepat di peta.',
                  style: AppTypography.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: AppDimensions.md),
        TextField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nama venue'),
        ),
        const SizedBox(height: AppDimensions.lg),
        SizedBox(
          width: double.infinity,
          height: AppDimensions.buttonHeightLg,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Simpan venue'),
          ),
        ),
        TextButton(
          onPressed: _saving
              ? null
              : () => setState(() {
                  _selected = null;
                  _pos = null;
                  _manual = false;
                }),
          child: const Text('Cari lokasi lain'),
        ),
      ],
    );
  }
}
