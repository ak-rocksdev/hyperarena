import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/core/utils/section_result.dart';

void main() {
  group('SectionResult', () {
    test('success holds the value', () {
      const r = SectionResult.success(42);
      expect(r.valueOrNull, 42);
      expect(r.errorOrNull, null);
      expect(r.isSuccess, true);
      expect(r.isFailure, false);
    });

    test('failure holds the error', () {
      final err = Exception('boom');
      final r = SectionResult<int>.failure(err, StackTrace.current);
      expect(r.valueOrNull, null);
      expect(r.errorOrNull, err);
      expect(r.isSuccess, false);
      expect(r.isFailure, true);
    });

    test('mapSuccess transforms only success', () {
      const a = SectionResult<int>.success(10);
      final b = a.mapSuccess((v) => v * 2);
      expect(b.valueOrNull, 20);

      final c = SectionResult<int>.failure(Exception('x'), null);
      final d = c.mapSuccess((v) => v * 2);
      expect(d.isFailure, true);
    });
  });
}
