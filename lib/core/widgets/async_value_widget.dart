import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic handler for AsyncValue — provides loading, error, and data states.
/// Usage: AsyncValueWidget(value: ref.watch(myProvider), data: (data) => ...)
class AsyncValueWidget<T> extends StatelessWidget {
  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final Widget Function()? loading;
  final Widget Function(Object error, StackTrace? stackTrace)? error;

  const AsyncValueWidget({
    super.key,
    required this.value,
    required this.data,
    this.loading,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return value.when(
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
      error: error ??
          (e, st) => Center(
                child: Text('Error: $e'),
              ),
      data: data,
    );
  }
}
