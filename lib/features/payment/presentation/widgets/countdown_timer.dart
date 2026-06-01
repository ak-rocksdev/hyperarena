import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({super.key, required this.expiresAt});
  final DateTime expiresAt;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Timer? _timer;
  Duration _remaining = Duration.zero;

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
    setState(() => _remaining = remaining.isNegative ? Duration.zero : remaining);
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
