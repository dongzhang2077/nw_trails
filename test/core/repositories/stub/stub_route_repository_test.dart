import 'package:flutter_test/flutter_test.dart';
import 'package:nw_trails/core/repositories/stub/stub_route_repository.dart';

void main() {
  group('StubRouteRepository', () {
    test('returns the five planned route definitions', () {
      final repository = StubRouteRepository();

      final routes = repository.getAll();

      expect(routes, hasLength(5));
      expect(
        routes.map((route) => route.id),
        orderedEquals(<String>['r1', 'r2', 'r3', 'r4', 'r5']),
      );
    });

    test('includes full-city route with all 15 landmarks', () {
      final repository = StubRouteRepository();

      final routes = repository.getAll();
      final completeRoute = routes.firstWhere((route) => route.id == 'r5');

      expect(completeRoute.landmarkIds, hasLength(15));
      expect(completeRoute.difficulty, 'Hard');
      expect(
        completeRoute.landmarkIds,
        orderedEquals(<String>[
          'l1',
          'l2',
          'l3',
          'l4',
          'l5',
          'l6',
          'l7',
          'l8',
          'l9',
          'l10',
          'l11',
          'l12',
          'l13',
          'l14',
          'l15',
        ]),
      );
    });
  });
}
