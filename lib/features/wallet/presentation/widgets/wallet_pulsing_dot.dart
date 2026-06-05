import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_colors.dart';

/// Small pulsing dot used to flag unseen wallet activity. Soft, slow pulse —
/// not the urgent red badge dot you'd see on a chat app. Green by default
/// (semantic: "new positive thing happened" — earnings/disbursements).
///
/// Composition: a solid filled dot surrounded by an expanding/fading ring.
/// The ring is the only animating part, so the static dot remains crisp
/// even mid-cycle (avoids the "wobbly dot" effect from scaling the fill).
class WalletPulsingDot extends StatefulWidget {
  const WalletPulsingDot({
    super.key,
    this.size = 8,
    this.color = AppColors.success,
  });

  /// Diameter of the filled dot in logical px. The ring grows to ~2.4× this.
  final double size;

  /// Both the dot and the ring share this hue; the ring fades from ~0.4 alpha
  /// to 0 across each cycle.
  final Color color;

  @override
  State<WalletPulsingDot> createState() => _WalletPulsingDotState();
}

class _WalletPulsingDotState extends State<WalletPulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size * 2.4,
      height: widget.size * 2.4,
      child: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) {
            final t = _controller.value; // 0 → 1
            final ringScale = 1.0 + t * 1.4; // 1 → 2.4
            final ringAlpha = (1 - t) * 0.4;
            return Stack(
              alignment: Alignment.center,
              children: [
                // Expanding fading ring
                Container(
                  width: widget.size * ringScale,
                  height: widget.size * ringScale,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: ringAlpha),
                  ),
                ),
                // Solid core dot
                Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
