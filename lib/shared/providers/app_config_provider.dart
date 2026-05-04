import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hyperarena/core/config/app_config.dart';

/// Legacy provider — kept only as a transitional override target.
/// Removed entirely in Task 9 once no consumer references it.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});
