import 'package:flutter/material.dart';
import 'package:hyperarena/core/widgets/empty_state.dart';
import 'package:hyperarena/features/venue/presentation/screens/venue_list_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Explore'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Lapangan'),
              Tab(text: 'Coach'),
              Tab(text: 'Sesi'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const VenueListScreen(),
            const EmptyState(
              message: 'Segera hadir',
              icon: Icons.school_outlined,
            ),
            const EmptyState(
              message: 'Segera hadir',
              icon: Icons.groups_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
