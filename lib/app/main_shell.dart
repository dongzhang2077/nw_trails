import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/features/awards/awards_page.dart';
import 'package:nw_trails/features/checkin/checkin_history_page.dart';
import 'package:nw_trails/features/landmarks/map_page.dart';
import 'package:nw_trails/features/routes/routes_page.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    const pages = <Widget>[
      MapPage(),
      CheckInHistoryPage(),
      AwardsPage(),
      RoutesPage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: appState.selectedTabIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: appState.selectedTabIndex,
        onDestinationSelected: appState.setSelectedTabIndex,
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Check-in',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Awards',
          ),
          NavigationDestination(
            icon: Icon(Icons.route_outlined),
            selectedIcon: Icon(Icons.route),
            label: 'Routes',
          ),
        ],
      ),
    );
  }
}
