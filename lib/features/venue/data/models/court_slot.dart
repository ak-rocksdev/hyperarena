import 'package:freezed_annotation/freezed_annotation.dart';

part 'court_slot.freezed.dart';
part 'court_slot.g.dart';

@freezed
class CourtSlot with _$CourtSlot {
  const factory CourtSlot({
    required String id,
    required String courtId,
    required DateTime date,
    required String startTime,
    required String endTime,
    required int price,
    @Default(false) bool isPeak,
    @Default(true) bool isAvailable,
  }) = _CourtSlot;

  factory CourtSlot.fromJson(Map<String, dynamic> json) =>
      _$CourtSlotFromJson(json);
}
