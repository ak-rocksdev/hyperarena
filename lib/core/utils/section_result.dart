import 'package:freezed_annotation/freezed_annotation.dart';

part 'section_result.freezed.dart';

/// A per-section result used by the coach dashboard summary so a single
/// fetch failure does not invalidate the whole dashboard. Widgets read their
/// section's `SectionResult` and render either data or an inline retry.
@freezed
sealed class SectionResult<T> with _$SectionResult<T> {
  const SectionResult._();

  const factory SectionResult.success(T value) = SectionSuccess<T>;
  const factory SectionResult.failure(Object error, StackTrace? stackTrace) =
      SectionFailure<T>;

  bool get isSuccess => this is SectionSuccess<T>;
  bool get isFailure => this is SectionFailure<T>;

  T? get valueOrNull => switch (this) {
        SectionSuccess<T>(:final value) => value,
        SectionFailure<T>() => null,
      };

  Object? get errorOrNull => switch (this) {
        SectionSuccess<T>() => null,
        SectionFailure<T>(:final error) => error,
      };

  SectionResult<R> mapSuccess<R>(R Function(T) f) => switch (this) {
        SectionSuccess<T>(:final value) => SectionResult.success(f(value)),
        SectionFailure<T>(:final error, :final stackTrace) =>
          SectionResult.failure(error, stackTrace),
      };
}
