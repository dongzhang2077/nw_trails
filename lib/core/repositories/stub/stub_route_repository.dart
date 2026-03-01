import 'package:nw_trails/core/models/route_plan.dart';
import 'package:nw_trails/core/repositories/route_repository.dart';

class StubRouteRepository implements RouteRepository {
  @override
  List<RoutePlan> getAll() {
    return const <RoutePlan>[
      RoutePlan(
        id: 'r1',
        name: 'Historic Downtown Walk',
        distanceKm: 2.5,
        durationMinutes: 45,
        difficulty: 'Easy',
        landmarkIds: <String>['l1', 'l2', 'l3', 'l4', 'l12'],
      ),
      RoutePlan(
        id: 'r2',
        name: 'Waterfront Trail',
        distanceKm: 3.8,
        durationMinutes: 70,
        difficulty: 'Medium',
        landmarkIds: <String>['l4', 'l6', 'l9', 'l11', 'l15', 'l12'],
      ),
      RoutePlan(
        id: 'r3',
        name: 'Food and Market Tour',
        distanceKm: 1.8,
        durationMinutes: 30,
        difficulty: 'Easy',
        landmarkIds: <String>['l9', 'l10', 'l11', 'l14'],
      ),
    ];
  }
}
