// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue_review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VenueReviewImpl _$$VenueReviewImplFromJson(Map<String, dynamic> json) =>
    _$VenueReviewImpl(
      id: json['id'] as String,
      reviewerId: json['reviewer_id'] as String,
      reviewerName: json['reviewer_name'] as String,
      venueId: json['venue_id'] as String,
      venueName: json['venue_name'] as String,
      bookingId: json['booking_id'] as String,
      courtName: json['court_name'] as String?,
      date: DateTime.parse(json['date'] as String),
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$$VenueReviewImplToJson(_$VenueReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reviewer_id': instance.reviewerId,
      'reviewer_name': instance.reviewerName,
      'venue_id': instance.venueId,
      'venue_name': instance.venueName,
      'booking_id': instance.bookingId,
      'court_name': instance.courtName,
      'date': instance.date.toIso8601String(),
      'rating': instance.rating,
      'comment': instance.comment,
    };
