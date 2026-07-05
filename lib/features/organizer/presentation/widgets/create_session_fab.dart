import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_colors.dart';
import 'package:hyperarena/routing/app_routes.dart';

/// Brand "Buat Sesi" floating action button, shared across the organizer
/// dashboard and session-list screens so the styling stays in one place.
///
/// Navigation uses [GoRouter.push] to the top-level create-session route, so
/// the pushed screen sits on top of whichever tab launched it — its Back
/// returns to the origin (Beranda → Beranda, Sesi → List Sesi) automatically.
///
/// [heroTag] MUST be unique per usage: the organizer shell keeps both tabs
/// mounted in an IndexedStack, so two FABs sharing a hero tag would collide.
class CreateSessionFab extends StatelessWidget {
  const CreateSessionFab({super.key, required this.heroTag});

  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      heroTag: heroTag,
      onPressed: () => context.push(AppRoutes.organizerCreateSession),
      icon: const Icon(Icons.add),
      label: const Text('Buat Sesi'),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: const StadiumBorder(),
    );
  }
}
