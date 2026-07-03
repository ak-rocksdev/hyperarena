import 'package:flutter/material.dart';

/// A circular, high-contrast icon control designed to float over imagery
/// (hero photos, maps) where the background is unpredictable.
///
/// A translucent dark scrim disc guarantees the white icon stays legible on
/// any photo — bright, dark, or busy — without darkening the whole image.
/// This is the standard "control over media" pattern (Airbnb, Google Maps).
///
/// The visible disc is 40×40 but the widget reserves a 48×48 tap target to
/// meet accessibility minimums.
class ScrimIconButton extends StatelessWidget {
  const ScrimIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onPressed;

  /// Read out by screen readers and used as the long-press tooltip.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: Material(
          color: Colors.black.withValues(alpha: 0.34),
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          // Soft shadow gives the disc an edge on dark photos where the
          // scrim itself would otherwise blend in.
          shadowColor: Colors.black.withValues(alpha: 0.4),
          elevation: 2,
          child: InkWell(
            onTap: onPressed,
            splashColor: Colors.white.withValues(alpha: 0.18),
            highlightColor: Colors.white.withValues(alpha: 0.08),
            child: Tooltip(
              message: semanticLabel ?? '',
              triggerMode: semanticLabel == null
                  ? TooltipTriggerMode.manual
                  : TooltipTriggerMode.longPress,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  icon,
                  size: 22,
                  color: Colors.white,
                  semanticLabel: semanticLabel,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A top-anchored gradient scrim (dark → transparent) for placing above a
/// hero photo. Keeps the OS status bar and any [ScrimIconButton] controls
/// legible over the top of an unpredictable image.
///
/// Wrap-free: drop it into the hero [Stack] after the image. It ignores
/// pointer events so taps fall through to the image (e.g. zoom).
class HeroTopScrim extends StatelessWidget {
  const HeroTopScrim({super.key, this.height = 120});

  final double height;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x61000000), Color(0x00000000)], // 38% → 0%
              ),
            ),
          ),
        ),
      ),
    );
  }
}
