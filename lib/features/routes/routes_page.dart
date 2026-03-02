import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/models/route_plan.dart';
import 'package:nw_trails/features/routes/route_detail_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  static const List<String> _filters = <String>[
    'All',
    'Easy',
    'Medium',
    'Hard',
  ];

  String _selectedFilter = 'All';

  Future<void> _openRouteDetail(RoutePlan route) async {
    final appState = AppScope.of(context);
    final bool? shouldFocusMap = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RouteDetailPage(routeId: route.id),
      ),
    );
    if (!mounted || shouldFocusMap != true) {
      return;
    }
    appState.setSelectedTabIndex(0);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Route ${route.name} is ready. Continue from the Map tab.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final List<RoutePlan> filteredRoutes = appState.routes
        .where((RoutePlan r) {
          return _selectedFilter == 'All' || r.difficulty == _selectedFilter;
        })
        .toList(growable: false);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Walking Routes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a route, review the stop timeline, and start your journey.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                for (final String filter in _filters)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: _selectedFilter == filter,
                      onSelected: (_) {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (filteredRoutes.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'No routes match the current difficulty filter.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          for (final RoutePlan route in filteredRoutes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RouteCard(
                route: route,
                onOpenDetail: () => _openRouteDetail(route),
              ),
            ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route, required this.onOpenDetail});

  final RoutePlan route;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final bool isActive = appState.activeRouteId == route.id;
    final int completedStops = appState.completedStopCountForRoute(route);
    final int totalStops = route.landmarkIds.length;
    final String? nextStopId = appState.nextUnvisitedLandmarkIdForRoute(
      route.id,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    route.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (isActive) const Chip(label: Text('Active')),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${route.distanceKm} km | ${route.durationMinutes} min '
              '| ${route.difficulty}',
            ),
            const SizedBox(height: 8),
            Text(
              'Progress: $completedStops/$totalStops stops',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 4),
            Text(
              nextStopId == null
                  ? 'All stops completed.'
                  : 'Next stop: ${appState.landmarkNameById(nextStopId)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: onOpenDetail,
              child: const Text('VIEW ROUTE DETAILS'),
            ),
          ],
        ),
      ),
    );
  }
}
