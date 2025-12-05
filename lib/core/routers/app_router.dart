import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/explore/explore_screen.dart';
import '../../screens/destinations/destination_detail_screen.dart';
import '../../screens/map/map_screen.dart';
import '../../screens/planner/trip_planner_screen.dart';
import '../../screens/guides/guides_screen.dart';
import '../../screens/tools/tools_screen.dart';
import '../../screens/phrasebook/phrasebook_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../widgets/common/main_scaffold.dart';

// Placeholder screens for now
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
}

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/explore',
            builder: (context, state) => const ExploreScreen(),
          ),
          GoRoute(
            path: '/map',
            builder: (context, state) => const MapScreen(),
          ),
          GoRoute(
            path: '/trips',
            builder: (context, state) => const TripPlannerScreen(),
          ),
          GoRoute(
            path: '/guides',
            builder: (context, state) => const GuidesScreen(),
          ),
          GoRoute(
            path: '/tools',
            builder: (context, state) => const ToolsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/destination/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DestinationDetailScreen(id: id);
        },
      ),
      GoRoute(
        path: '/phrasebook',
        builder: (context, state) => const PhrasebookScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
