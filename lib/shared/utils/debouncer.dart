import 'dart:async';

/// Lightweight debouncer for live-search and similar input flows.
/// Default 350ms — snappy enough to feel reactive without firing a request
/// on every keystroke. Always `dispose()` from the widget's `dispose()`.
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 350)});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
