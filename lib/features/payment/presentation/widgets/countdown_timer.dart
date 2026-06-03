import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    super.key,
    required this.expiresAt,
    this.onExpired,
  });

  final DateTime expiresAt;

  /// Called exactly once when the countdown reaches zero.
  /// Safe to trigger navigation from here — fires after the current frame.
  final VoidCallback? onExpired;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _calledExpired = false;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    final remaining = widget.expiresAt.difference(DateTime.now());
    final isZero = remaining.isNegative || remaining == Duration.zero;
    setState(() => _remaining = isZero ? Duration.zero : remaining);

    if (isZero && !_calledExpired) {
      _calledExpired = true;
      // Fire after the current frame so callers can safely trigger navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onExpired?.call();
      });
    }
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final expired = _remaining == Duration.zero;
    return Text(
      expired ? 'Kedaluwarsa' : 'Berlaku: ${_format(_remaining)}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: expired ? Colors.red : Colors.amber.shade800,
      ),
    );
  }
}
