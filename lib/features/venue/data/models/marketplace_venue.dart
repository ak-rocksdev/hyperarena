// lib/features/venue/data/models/marketplace_venue.dart
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'marketplace_venue.freezed.dart';
part 'marketplace_venue.g.dart';

String _idFromJson(dynamic v) => v.toString();

@freezed
class MarketplaceVenue with _$MarketplaceVenue {
  const factory MarketplaceVenue({
    @JsonKey(fromJson: _idFromJson) required String id,
    required String name,
    required String status,
    SportInfo? sport,
    VenueLocation? location,
    @Default([]) List<VenuePhoto> photos,
  }) = _MarketplaceVenue;

  factory MarketplaceVenue.fromJson(Map<String, dynamic> json) =>
      _$MarketplaceVenueFromJson(json);
}

@freezed
class VenueLocation with _$VenueLocation {
  const factory VenueLocation({
    required String name,
    String? address,
    double? lat,
    double? lng,
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
