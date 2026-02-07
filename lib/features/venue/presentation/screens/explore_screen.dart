import 'package:flutter/material.dart';
import 'package:hyperarena/features/coach/presentation/screens/coach_list_screen.dart';
import 'package:hyperarena/features/session/presentation/screens/session_list_screen.dart';
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
        body: const TabBarView(
          children: [
            VenueListScreen(),
            CoachListScreen(),
            SessionListScreen(),
          ],
        ),
      ),
    );
  }
}
