import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/models/route_plan.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);

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
            'Pick a route and continue on the map tab.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          for (final RoutePlan route in appState.routes)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RouteCard(route: route),
            ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({required this.route});

  final RoutePlan route;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final bool isActive = appState.activeRouteId == route.id;

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
                if (isActive)
                  const Chip(
                    label: Text('Active'),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${route.distanceKm} km | ${route.durationMinutes} min '
              '| ${route.difficulty}',
            ),
            const SizedBox(height: 8),
            Text(
              'Stops: '
              '${route.landmarkIds.map(appState.landmarkNameById).join(', ')}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 10),
            FilledButton.tonal(
              onPressed: () {
                appState.startRoute(route.id);
                appState.setSelectedTabIndex(0);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Started ${route.name}. Continue from the Map tab.',
                    ),
                  ),
                );
              },
              child: const Text('START THIS ROUTE'),
            ),
          ],
        ),
      ),
    );
  }
}
