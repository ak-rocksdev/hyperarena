import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hyperarena/features/venue/data/models/court.dart';

part 'venue.freezed.dart';
part 'venue.g.dart';

@freezed
class Venue with _$Venue {
  const factory Venue({
    required String id,
    required String ownerId,
    required String name,
    required String description,
    required String address,
    required String city,
    required double latitude,
    required double longitude,
    String? phone,
    String? whatsappNumber,
    @Default([]) List<String> facilities,
    @Default([]) List<String> photos,
    @Default(false) bool isVerified,
    @Default(0.0) double avgRating,
    @Default(0) int totalReviews,
    @Default([]) List<Court> courts,
  }) = _Venue;

  factory Venue.fromJson(Map<String, dynamic> json) => _$VenueFromJson(json);
}
