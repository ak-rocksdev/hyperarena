import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hyperarena/features/coach/providers/coach_id_provider.dart';

void main() {
  test('coachIdProvider returns the mock coach id during transition', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final id = container.read(coachIdProvider);
    expect(id, 'coach-001');
  });
}
