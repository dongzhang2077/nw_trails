import 'package:nw_trails/core/services/location_service.dart';

class StubLocationService implements LocationService {
  StubLocationService({
    Set<String>? permissionDeniedLandmarkIds,
    Map<String, int>? distanceByLandmark,
  })  : _permissionDeniedLandmarkIds =
            permissionDeniedLandmarkIds ?? <String>{'l13'},
        _distanceByLandmark = distanceByLandmark ??
            <String, int>{
              'l1': 32,
              'l2': 48,
              'l3': 72,
              'l4': 18,
              'l5': 55,
              'l6': 40,
              'l7': 28,
              'l8': 63,
              'l9': 24,
              'l10': 16,
              'l11': 45,
              'l12': 38,
              'l13': 22,
              'l14': 14,
              'l15': 52,
            };

  final Set<String> _permissionDeniedLandmarkIds;
  final Map<String, int> _distanceByLandmark;

  @override
  Future<ProximityCheckResult> checkProximity({
    required String landmarkId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 160));

    if (_permissionDeniedLandmarkIds.contains(landmarkId)) {
      return const ProximityCheckResult(
        permissionGranted: false,
        distanceMeters: 9999,
      );
    }

    return ProximityCheckResult(
      permissionGranted: true,
      distanceMeters: _distanceByLandmark[landmarkId] ?? 42,
    );
  }
}
