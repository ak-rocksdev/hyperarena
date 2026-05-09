import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/shared/providers/network_providers.dart';

/// Persisted toggle controlling whether monetary values are rendered as their
/// real digits or masked (e.g. `Rp ••••••`). Default is masked — we treat
/// money as sensitive-by-default since organizers often demo the app on a
/// projector or hand the phone around.
final moneyVisibilityProvider =
    StateNotifierProvider<MoneyVisibilityNotifier, bool>((ref) {
      return MoneyVisibilityNotifier(ref);
    });

class MoneyVisibilityNotifier extends StateNotifier<bool> {
  MoneyVisibilityNotifier(this._ref) : super(false) {
    final stored = _ref.read(sharedPreferencesProvider).getBool(_prefKey);
    if (stored != null) state = stored;
  }

  static const _prefKey = 'money_visibility_visible';
  final Ref _ref;

  Future<void> toggle() async {
    state = !state;
    await _ref.read(sharedPreferencesProvider).setBool(_prefKey, state);
  }
}
