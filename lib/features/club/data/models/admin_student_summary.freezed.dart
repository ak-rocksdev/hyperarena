// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_student_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdminStudentSummary _$AdminStudentSummaryFromJson(Map<String, dynamic> json) {
  return _AdminStudentSummary.fromJson(json);
}

/// @nodoc
mixin _$AdminStudentSummary {
  @JsonKey(fromJson: idFromJson)
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this AdminStudentSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdminStudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminStudentSummaryCopyWith<AdminStudentSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminStudentSummaryCopyWith<$Res> {
  factory $AdminStudentSummaryCopyWith(
    AdminStudentSummary value,
    $Res Function(AdminStudentSummary) then,
  ) = _$AdminStudentSummaryCopyWithImpl<$Res, AdminStudentSummary>;
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class _$AdminStudentSummaryCopyWithImpl<$Res, $Val extends AdminStudentSummary>
    implements $AdminStudentSummaryCopyWith<$Res> {
  _$AdminStudentSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminStudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? photoUrls = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            dateOfBirth: freezed == dateOfBirth
                ? _value.dateOfBirth
                : dateOfBirth // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            photoUrls: freezed == photoUrls
                ? _value.photoUrls
                : photoUrls // ignore: cast_nullable_to_non_nullable
                      as Map<String, String>?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdminStudentSummaryImplCopyWith<$Res>
    implements $AdminStudentSummaryCopyWith<$Res> {
  factory _$$AdminStudentSummaryImplCopyWith(
    _$AdminStudentSummaryImpl value,
    $Res Function(_$AdminStudentSummaryImpl) then,
  ) = __$$AdminStudentSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @JsonKey(fromJson: idFromJson) String id,
    @JsonKey(name: 'first_name') String? firstName,
    @JsonKey(name: 'last_name') String? lastName,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    String? gender,
    @JsonKey(name: 'photo_urls') Map<String, String>? photoUrls,
    @JsonKey(name: 'created_at') DateTime? createdAt,
  });
}

/// @nodoc
class __$$AdminStudentSummaryImplCopyWithImpl<$Res>
    extends _$AdminStudentSummaryCopyWithImpl<$Res, _$AdminStudentSummaryImpl>
    implements _$$AdminStudentSummaryImplCopyWith<$Res> {
  __$$AdminStudentSummaryImplCopyWithImpl(
    _$AdminStudentSummaryImpl _value,
    $Res Function(_$AdminStudentSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdminStudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? photoUrls = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$AdminStudentSummaryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        dateOfBirth: freezed == dateOfBirth
            ? _value.dateOfBirth
            : dateOfBirth // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        photoUrls: freezed == photoUrls
            ? _value._photoUrls
            : photoUrls // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdminStudentSummaryImpl implements _AdminStudentSummary {
  const _$AdminStudentSummaryImpl({
    @JsonKey(fromJson: idFromJson) required this.id,
    @JsonKey(name: 'first_name') this.firstName,
    @JsonKey(name: 'last_name') this.lastName,
    @JsonKey(name: 'date_of_birth') this.dateOfBirth,
    this.gender,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    @JsonKey(name: 'created_at') this.createdAt,
  }) : _photoUrls = photoUrls;

  factory _$AdminStudentSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdminStudentSummaryImplFromJson(json);

  @override
  @JsonKey(fromJson: idFromJson)
  final String id;
  @override
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'date_of_birth')
  final DateTime? dateOfBirth;
  @override
  final String? gender;
  final Map<String, String>? _photoUrls;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls {
    final value = _photoUrls;
    if (value == null) return null;
    if (_photoUrls is EqualUnmodifiableMapView) return _photoUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @override
  String toString() {
    return 'AdminStudentSummary(id: $id, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, gender: $gender, photoUrls: $photoUrls, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminStudentSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            const DeepCollectionEquality().equals(
              other._photoUrls,
              _photoUrls,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    firstName,
    lastName,
    dateOfBirth,
    gender,
    const DeepCollectionEquality().hash(_photoUrls),
    createdAt,
  );

  /// Create a copy of AdminStudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminStudentSummaryImplCopyWith<_$AdminStudentSummaryImpl> get copyWith =>
      __$$AdminStudentSummaryImplCopyWithImpl<_$AdminStudentSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdminStudentSummaryImplToJson(this);
  }
}

abstract class _AdminStudentSummary implements AdminStudentSummary {
  const factory _AdminStudentSummary({
    @JsonKey(fromJson: idFromJson) required final String id,
    @JsonKey(name: 'first_name') final String? firstName,
    @JsonKey(name: 'last_name') final String? lastName,
    @JsonKey(name: 'date_of_birth') final DateTime? dateOfBirth,
    final String? gender,
    @JsonKey(name: 'photo_urls') final Map<String, String>? photoUrls,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
  }) = _$AdminStudentSummaryImpl;

  factory _AdminStudentSummary.fromJson(Map<String, dynamic> json) =
      _$AdminStudentSummaryImpl.fromJson;

  @override
  @JsonKey(fromJson: idFromJson)
  String get id;
  @override
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'date_of_birth')
  DateTime? get dateOfBirth;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'photo_urls')
  Map<String, String>? get photoUrls;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;

  /// Create a copy of AdminStudentSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminStudentSummaryImplCopyWith<_$AdminStudentSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
