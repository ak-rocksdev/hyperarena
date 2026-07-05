import 'package:flutter/material.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/theme/app_surfaces.dart';
import 'package:hyperarena/core/theme/app_typography.dart';

/// Brand teal header for the create-session flow — the same gradient world as
/// the organizer dashboard hero. Carries the back affordance, the flow title,
/// and a two-segment step rail naming each phase (the form genuinely is a
/// two-step sequence, so the numbering encodes real order).
class CreateSessionHeader extends StatelessWidget {
  const CreateSessionHeader({
    super.key,
    required this.step,
    required this.onBack,
  });

  /// 0 = Detail, 1 = Jadwal & rincian.
  final int step;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppSurfaces.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.md,
            AppDimensions.sm,
            AppDimensions.lg,
            AppDimensions.base,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _GlassBack(onTap: onBack),
                  const SizedBox(width: AppDimensions.xs),
                  Text(
                    'Buat sesi',
                    style: AppTypography.headingMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Langkah ${step + 1}/2',
                    style: AppTypography.labelMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.base),
              Padding(
                padding: const EdgeInsets.only(left: AppDimensions.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: _RailSegment(
                        index: 0,
                        step: step,
                        label: 'Detail',
                        caption: 'Siapa & apa',
                      ),
                    ),
                    const SizedBox(width: AppDimensions.sm),
                    Expanded(
                      child: _RailSegment(
                        index: 1,
                        step: step,
                        label: 'Jadwal & rincian',
                        caption: 'Kapan & biaya',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailSegment extends StatelessWidget {
  const _RailSegment({
    required this.index,
    required this.step,
    required this.label,
    required this.caption,
  });

  final int index;
  final int step;
  final String label;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final active = index == step;
    final done = index < step;
    final reached = active || done;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          height: 4,
          decoration: BoxDecoration(
            color: reached ? Colors.white : Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),
        const SizedBox(height: AppDimensions.sm),
        Row(
          children: [
            if (done)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.check_circle,
                    size: 13, color: Colors.white.withValues(alpha: 0.9)),
              ),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.labelMedium.copyWith(
                  color: reached
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 1),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.caption.copyWith(
            color: Colors.white.withValues(alpha: reached ? 0.7 : 0.45),
          ),
        ),
      ],
    );
  }
}

class _GlassBack extends StatelessWidget {
  const _GlassBack({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
