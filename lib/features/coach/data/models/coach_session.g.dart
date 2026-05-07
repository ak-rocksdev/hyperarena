// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachSessionImpl _$$CoachSessionImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionImpl(
  id: idFromJson(json['id']),
  type: json['type'] as String?,
  startAt: tenantWallClockFromJson(json['start_at'] as String),
  durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 0,
  capacity: (json['capacity'] as num?)?.toInt() ?? 0,
  status: json['status'] as String?,
  notes: json['notes'] as String?,
  name: json['name'] as String? ?? 'Sesi Latihan',
  completionState: json['completion_state'] as String? ?? 'not_yet',
  bookedStudentsCount: (json['booked_students_count'] as num?)?.toInt() ?? 0,
  venue: json['venue'] == null
      ? null
      : CoachSessionVenue.fromJson(json['venue'] as Map<String, dynamic>),
  coaches:
      (json['coaches'] as List<dynamic>?)
          ?.map((e) => CoachSessionCoach.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  sessionStudents:
      (json['session_students'] as List<dynamic>?)
          ?.map((e) => CoachSessionStudent.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  attendances:
      (json['attendances'] as List<dynamic>?)
          ?.map(
            (e) => CoachSessionAttendance.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  title: json['title'] as String?,
  displayTitle: json['display_title'] as String?,
  photoPath: json['photo_path'] as String?,
  photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

Map<String, dynamic> _$$CoachSessionImplToJson(_$CoachSessionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'start_at': instance.startAt.toIso8601String(),
      'duration_minutes': instance.durationMinutes,
      'capacity': instance.capacity,
      'status': instance.status,
      'notes': instance.notes,
      'name': instance.name,
      'completion_state': instance.completionState,
      'booked_students_count': instance.bookedStudentsCount,
      'venue': instance.venue,
      'coaches': instance.coaches,
      'session_students': instance.sessionStudents,
      'attendances': instance.attendances,
      'title': instance.title,
      'display_title': instance.displayTitle,
      'photo_path': instance.photoPath,
      'photo_urls': instance.photoUrls,
    };

_$CoachSessionVenueImpl _$$CoachSessionVenueImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionVenueImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  location: json['location'] == null
      ? null
      : CoachSessionVenueLocation.fromJson(
          json['location'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$CoachSessionVenueImplToJson(
  _$CoachSessionVenueImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'location': instance.location,
};

_$CoachSessionVenueLocationImpl _$$CoachSessionVenueLocationImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionVenueLocationImpl(
  name: json['name'] as String,
  address: json['address'] as String?,
  lat: latLngFromJson(json['lat']),
  lng: latLngFromJson(json['lng']),
);

Map<String, dynamic> _$$CoachSessionVenueLocationImplToJson(
  _$CoachSessionVenueLocationImpl instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'lat': instance.lat,
  'lng': instance.lng,
};

_$CoachSessionCoachImpl _$$CoachSessionCoachImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionCoachImpl(
  id: idFromJson(json['id']),
  user: json['user'] == null
      ? null
      : CoachSessionUser.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$CoachSessionCoachImplToJson(
  _$CoachSessionCoachImpl instance,
) => <String, dynamic>{'id': instance.id, 'user': instance.user};

_$CoachSessionUserImpl _$$CoachSessionUserImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionUserImpl(
  id: idFromJson(json['id']),
  name: json['name'] as String,
  email: json['email'] as String?,
);

Map<String, dynamic> _$$CoachSessionUserImplToJson(
  _$CoachSessionUserImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
};

_$CoachSessionStudentImpl _$$CoachSessionStudentImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionStudentImpl(
  id: idFromJson(json['id']),
  studentProfileId: idFromJson(json['student_profile_id']),
  cancelledAt: json['cancelled_at'] == null
      ? null
      : DateTime.parse(json['cancelled_at'] as String),
  studentProfile: json['student_profile'] == null
      ? null
      : StudentProfile.fromJson(
          json['student_profile'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$CoachSessionStudentImplToJson(
  _$CoachSessionStudentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_profile_id': instance.studentProfileId,
  'cancelled_at': instance.cancelledAt?.toIso8601String(),
  'student_profile': instance.studentProfile,
};

_$StudentProfileImpl _$$StudentProfileImplFromJson(Map<String, dynamic> json) =>
    _$StudentProfileImpl(
      id: idFromJson(json['id']),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      photoPath: json['photo_path'] as String?,
      photoUrls: (json['photo_urls'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$StudentProfileImplToJson(
  _$StudentProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'photo_path': instance.photoPath,
  'photo_urls': instance.photoUrls,
};

_$CoachSessionAttendanceImpl _$$CoachSessionAttendanceImplFromJson(
  Map<String, dynamic> json,
) => _$CoachSessionAttendanceImpl(
  id: idFromJson(json['id']),
  studentProfileId: idFromJson(json['student_profile_id']),
  status: json['status'] as String,
  markedByUser: json['marked_by_user'] == null
      ? null
      : CoachSessionUser.fromJson(
          json['marked_by_user'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$$CoachSessionAttendanceImplToJson(
  _$CoachSessionAttendanceImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'student_profile_id': instance.studentProfileId,
  'status': instance.status,
  'marked_by_user': instance.markedByUser,
};
