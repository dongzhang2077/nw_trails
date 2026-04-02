import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/features/account/account_page.dart';
import 'package:nw_trails/features/awards/awards_page.dart';
import 'package:nw_trails/features/checkin/checkin_history_page.dart';
import 'package:nw_trails/features/landmarks/map_page.dart';
import 'package:nw_trails/features/routes/routes_page.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

    const List<Widget> pages = <Widget>[
      MapPage(),
      CheckInHistoryPage(),
      AwardsPage(),
      RoutesPage(),
      AccountPage(),
    ];

    return Scaffold(
      body: Column(
        children: <Widget>[
          if (appState.isSyncingBackend)
            const LinearProgressIndicator(minHeight: 3),
          if (appState.syncError != null && appState.isAuthenticated)
            MaterialBanner(
              content: Text(appState.syncError!),
              leading: const Icon(Icons.sync_problem_outlined),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    appState.retryBackendSync();
                  },
                  child: const Text('RETRY'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: appState.selectedTabIndex,
              children: pages,
            ),
          ),
        ],
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
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
