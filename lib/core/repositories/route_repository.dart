import 'package:nw_trails/core/models/route_plan.dart';

abstract class RouteRepository {
  List<RoutePlan> getAll();
}
