import 'package:freezed_annotation/freezed_annotation.dart';

part 'sport_filter.freezed.dart';
part 'sport_filter.g.dart';

@freezed
class SportFilter with _$SportFilter {
  const factory SportFilter({
    required int id,
    required String name,
    String? icon,
  }) = _SportFilter;

  factory SportFilter.fromJson(Map<String, dynamic> json) =>
      _$SportFilterFromJson(json);
}
