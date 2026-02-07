import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// A radar/pentagon chart using CustomPaint for 5 assessment axes.
class RadarChartWidget extends StatelessWidget {
  final List<double> values; // 5 values, each 0.0-1.0 (normalized from 1-10)
  final List<String> labels; // 5 labels
  final double size;
  final Color? fillColor;
  final Color? borderColor;

  const RadarChartWidget({
    super.key,
    required this.values,
    this.labels = const [
      'Teknik',
      'Stamina',
      'Taktik',
      'Mental',
      'Konsistensi',
    ],
    this.size = 200,
    this.fillColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarChartPainter(
          values: values,
          labels: labels,
          fillColor: fillColor ?? AppColors.primary.withValues(alpha: 0.3),
          borderColor: borderColor ?? AppColors.primary,
          gridColor: AppColors.neutral200,
          labelStyle: AppTypography.caption,
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color fillColor;
  final Color borderColor;
  final Color gridColor;
  final TextStyle labelStyle;

  _RadarChartPainter({
    required this.values,
    required this.labels,
    required this.fillColor,
    required this.borderColor,
    required this.gridColor,
    required this.labelStyle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        min(size.width, size.height) / 2 - 30; // Leave space for labels
    final sides = values.length;
    final angle = 2 * pi / sides;

    // Draw grid levels (at 25%, 50%, 75%, 100%)
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var level = 0.25; level <= 1.0; level += 0.25) {
      final gridPath = Path();
      for (var i = 0; i < sides; i++) {
        final x = center.dx + radius * level * cos(angle * i - pi / 2);
        final y = center.dy + radius * level * sin(angle * i - pi / 2);
        if (i == 0) {
          gridPath.moveTo(x, y);
        } else {
          gridPath.lineTo(x, y);
        }
      }
      gridPath.close();
      canvas.drawPath(gridPath, gridPaint);
    }

    // Draw axes
    for (var i = 0; i < sides; i++) {
      final x = center.dx + radius * cos(angle * i - pi / 2);
      final y = center.dy + radius * sin(angle * i - pi / 2);
      canvas.drawLine(center, Offset(x, y), gridPaint);
    }

    // Draw data polygon
    final fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final borderPaintStroke = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final dataPath = Path();
    for (var i = 0; i < sides; i++) {
      final value = values[i].clamp(0.0, 1.0);
      final x = center.dx + radius * value * cos(angle * i - pi / 2);
      final y = center.dy + radius * value * sin(angle * i - pi / 2);
      if (i == 0) {
        dataPath.moveTo(x, y);
      } else {
        dataPath.lineTo(x, y);
      }
    }
    dataPath.close();
    canvas.drawPath(dataPath, fillPaint);
    canvas.drawPath(dataPath, borderPaintStroke);

    // Draw data points
    final dotPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.fill;

    for (var i = 0; i < sides; i++) {
      final value = values[i].clamp(0.0, 1.0);
      final x = center.dx + radius * value * cos(angle * i - pi / 2);
      final y = center.dy + radius * value * sin(angle * i - pi / 2);
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }

    // Draw labels
    for (var i = 0; i < sides; i++) {
      final labelRadius = radius + 20;
      final x = center.dx + labelRadius * cos(angle * i - pi / 2);
      final y = center.dy + labelRadius * sin(angle * i - pi / 2);

      final textSpan = TextSpan(text: labels[i], style: labelStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final offset = Offset(
        x - textPainter.width / 2,
        y - textPainter.height / 2,
      );
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return values != oldDelegate.values ||
        fillColor != oldDelegate.fillColor ||
        borderColor != oldDelegate.borderColor;
  }
}
