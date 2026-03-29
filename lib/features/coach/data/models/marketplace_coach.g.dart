// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketplace_coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MarketplaceCoachImpl _$$MarketplaceCoachImplFromJson(
  Map<String, dynamic> json,
) => _$MarketplaceCoachImpl(
  id: idFromJson(json['id']),
  bio: json['bio'] as String?,
  user: json['user'] == null
      ? null
      : CoachUser.fromJson(json['user'] as Map<String, dynamic>),
  sport: json['sport'] == null
      ? null
      : SportInfo.fromJson(json['sport'] as Map<String, dynamic>),
  ratePerSession: (json['rate_per_session'] as num?)?.toInt(),
  currency: json['currency'] as String?,
);

Map<String, dynamic> _$$MarketplaceCoachImplToJson(
  _$MarketplaceCoachImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'bio': instance.bio,
  'user': instance.user,
  'sport': instance.sport,
  'rate_per_session': instance.ratePerSession,
  'currency': instance.currency,
};

_$CoachUserImpl _$$CoachUserImplFromJson(Map<String, dynamic> json) =>
    _$CoachUserImpl(
      name: json['name'] as String,
      photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$CoachUserImplToJson(_$CoachUserImpl instance) =>
    <String, dynamic>{'name': instance.name, 'photo_urls': instance.photoUrls};
