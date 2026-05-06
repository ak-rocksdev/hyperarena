// lib/features/venue/data/models/marketplace_venue.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/shared/data/json_converters.dart';

part 'marketplace_venue.freezed.dart';
part 'marketplace_venue.g.dart';

@freezed
class MarketplaceVenue with _$MarketplaceVenue {
  const factory MarketplaceVenue({
    @JsonKey(fromJson: idFromJson) required String id,
    required String name,
    @Default('active') String status,
    SportInfo? sport,
    VenueLocation? location,
    @Default([]) List<VenuePhoto> photos,
    @JsonKey(name: 'tenant_id') int? tenantId,
  }) = _MarketplaceVenue;

  factory MarketplaceVenue.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceVenueFromJson(json);
}

@freezed
class VenueLocation with _$VenueLocation {
  const factory VenueLocation({
    required String name,
    String? address,
    @JsonKey(fromJson: latLngFromJson) double? lat,
    @JsonKey(fromJson: latLngFromJson) double? lng,
  }) = _VenueLocation;

  factory VenueLocation.fromJson(Map<String, dynamic> json) =>
      _$VenueLocationFromJson(json);
}

@freezed
class VenuePhoto with _$VenuePhoto {
  const factory VenuePhoto({
    required String url,
    String? caption,
  }) = _VenuePhoto;

  factory VenuePhoto.fromJson(Map<String, dynamic> json) =>
      _$VenuePhotoFromJson(json);
}

@freezed
class SportInfo with _$SportInfo {
  const factory SportInfo({
    required int id,
    required String name,
  }) = _SportInfo;

  factory SportInfo.fromJson(Map<String, dynamic> json) =>
      _$SportInfoFromJson(json);
}
