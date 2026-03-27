import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_shadows.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shows venue location with optional map preview and "Buka di Maps" button.
///
/// - If [lat] and [lng] are provided: shows embedded map + marker + button.
/// - If only [address] is provided: shows address text only, no map.
/// - If [address] is also null/empty: widget renders nothing (SizedBox.shrink).
class VenueLocationSection extends StatelessWidget {
  final String? venueName;
  final String? address;
  final double? lat;
  final double? lng;

  const VenueLocationSection({
    super.key,
    this.venueName,
    this.address,
    this.lat,
    this.lng,
  });

  bool get _hasCoordinates => lat != null && lng != null;
  bool get _hasAddress => address != null && address!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    // Hide entirely if no location data at all
    if (!_hasCoordinates && !_hasAddress) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi', style: AppTypography.titleMedium),
        const SizedBox(height: AppDimensions.sm),

        // Map preview (only when lat/lng available)
        if (_hasCoordinates) ...[
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
              boxShadow: AppShadows.sm,
            ),
            clipBehavior: Clip.antiAlias,
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat!, lng!),
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.hyperarena.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat!, lng!),
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
        ],

        // Address + venue name
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            color: AppSurfaces.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            boxShadow: AppShadows.xs,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (venueName != null && venueName!.isNotEmpty) ...[
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 18,
                      color: AppColors.neutral400,
                    ),
                    const SizedBox(width: AppDimensions.xs),
                    Expanded(
                      child: Text(
                        venueName!,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              if (_hasAddress) ...[
                if (venueName != null && venueName!.isNotEmpty)
                  const SizedBox(height: AppDimensions.xs),
                Padding(
                  padding: const EdgeInsets.only(left: 26),
                  child: Text(
                    address!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              if (_hasCoordinates) ...[
                const SizedBox(height: AppDimensions.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openInMaps(),
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Buka di Maps'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.xl),
      ],
    );
  }

  Future<void> _openInMaps() async {
    if (!_hasCoordinates) return;
    final googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    }
  }
}
