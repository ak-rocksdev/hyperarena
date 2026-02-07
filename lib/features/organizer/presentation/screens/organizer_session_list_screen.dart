import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hyperarena/core/theme/app_dimensions.dart';
import 'package:hyperarena/core/widgets/async_value_widget.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/organizer/presentation/widgets/organizer_session_card.dart';
import 'package:hyperarena/features/organizer/providers/organizer_providers.dart';
import 'package:hyperarena/features/session/data/models/open_session.dart';
import 'package:hyperarena/routing/app_routes.dart';

class OrganizerSessionListScreen extends ConsumerStatefulWidget {
  const OrganizerSessionListScreen({super.key});

  @override
  ConsumerState<OrganizerSessionListScreen> createState() =>
      _OrganizerSessionListScreenState();
}

class _OrganizerSessionListScreenState
    extends ConsumerState<OrganizerSessionListScreen> {
  bool _showUpcoming = true;

  Future<void> _onRefresh() async {
    ref.invalidate(organizerUpcomingSessionsProvider);
    ref.invalidate(organizerPastSessionsProvider);

    if (_showUpcoming) {
      await ref.read(organizerUpcomingSessionsProvider.future);
    } else {
      await ref.read(organizerPastSessionsProvider.future);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(
      _showUpcoming
          ? organizerUpcomingSessionsProvider
          : organizerPastSessionsProvider,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Sesi Saya')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.organizerCreateSession),
        icon: const Icon(Icons.add),
        label: const Text('Buat Sesi'),
      ),
      body: Column(
        children: [
          // ── Toggle row ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenHorizontal,
              vertical: AppDimensions.sm,
            ),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Mendatang')),
                ButtonSegment(value: false, label: Text('Selesai')),
              ],
              selected: {_showUpcoming},
              onSelectionChanged: (Set<bool> selection) {
                setState(() => _showUpcoming = selection.first);
              },
            ),
          ),

          // ── Session list ────────────────────────────────────────
          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: AsyncValueWidget<List<OpenSession>>(
                value: sessionsAsync,
                data: (sessions) {
                  if (sessions.isEmpty) {
                    return _showUpcoming
                        ? const EmptyState(
                            message: 'Belum ada sesi mendatang',
                            icon: Icons.event_available_outlined,
                          )
                        : const EmptyState(
                            message: 'Belum ada sesi yang selesai',
                            icon: Icons.history_outlined,
                          );
                  }

                  return ListView.builder(
                    itemCount: sessions.length,
                    padding: const EdgeInsets.all(
                      AppDimensions.screenHorizontal,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimensions.sm,
                        ),
                        child: OrganizerSessionCard(
                          session: sessions[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
