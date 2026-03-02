import 'package:flutter/material.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/models/route_plan.dart';

class RouteDetailPage extends StatelessWidget {
  const RouteDetailPage({required this.routeId, super.key});

  final String routeId;

  @override
  Widget build(BuildContext context) {
    final appState = AppScope.of(context);
    final RoutePlan? route = appState.findRouteById(routeId);

    if (route == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route detail')),
        body: const Center(
          child: Text('Route not found. Please return to Routes.'),
        ),
      );
    }

    final int completedStops = appState.completedStopCountForRoute(route);
    final int totalStops = route.landmarkIds.length;
    final String? nextStopId = appState.nextUnvisitedLandmarkIdForRoute(
      route.id,
    );
    final bool isRouteCompleted = nextStopId == null;
    final bool isActiveRoute = appState.activeRouteId == route.id;

    final String actionLabel = isRouteCompleted
        ? 'BACK TO MAP'
        : isActiveRoute
        ? 'CONTINUE THIS ROUTE'
        : 'START THIS ROUTE';

    return Scaffold(
      appBar: AppBar(title: const Text('Route detail')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(route.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                _MetaChip(
                  icon: Icons.route_outlined,
                  label: '${route.distanceKm.toStringAsFixed(1)} km',
                ),
                _MetaChip(
                  icon: Icons.schedule,
                  label: '${route.durationMinutes} min',
                ),
                _MetaChip(icon: Icons.flag_outlined, label: route.difficulty),
                _MetaChip(
                  icon: Icons.checklist,
                  label: '$completedStops/$totalStops stops',
                ),
              ],
            ),
            const SizedBox(height: 12),
            Card(
              child: Container(
                height: 150,
                padding: const EdgeInsets.all(14),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.map_outlined,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Route overview',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'From ${appState.landmarkNameById(route.landmarkIds.first)} '
                      'to ${appState.landmarkNameById(route.landmarkIds.last)}.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      nextStopId == null
                          ? 'All stops completed for this route.'
                          : 'Next suggested stop: '
                                '${appState.landmarkNameById(nextStopId)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Stop timeline',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (int i = 0; i < route.landmarkIds.length; i++)
              _RouteStopTile(
                index: i + 1,
                landmarkName: appState.landmarkNameById(route.landmarkIds[i]),
                isVisited: appState.hasVisitedLandmark(route.landmarkIds[i]),
                isNext: route.landmarkIds[i] == nextStopId,
              ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                if (!isRouteCompleted) {
                  appState.startRoute(route.id);
                }
                Navigator.of(context).pop(true);
              },
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }
}

class _RouteStopTile extends StatelessWidget {
  const _RouteStopTile({
    required this.index,
    required this.landmarkName,
    required this.isVisited,
    required this.isNext,
  });

  final int index;
  final String landmarkName;
  final bool isVisited;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;
    final String stateLabel = isVisited
        ? 'Completed'
        : isNext
        ? 'Next stop'
        : 'Upcoming';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isVisited
              ? primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          child: isVisited
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Text(index.toString()),
        ),
        title: Text(landmarkName),
        subtitle: Text(stateLabel),
      ),
    );
  }
}
