class ProximityCheckResult {
  const ProximityCheckResult({
    required this.permissionGranted,
    required this.distanceMeters,
  });

  final bool permissionGranted;
  final int distanceMeters;
}

abstract class LocationService {
  Future<ProximityCheckResult> checkProximity({
    required String landmarkId,
  });
}
