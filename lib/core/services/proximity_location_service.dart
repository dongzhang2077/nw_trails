import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/core/services/location_service.dart';

class ProximityLocationService implements LocationService {
  const ProximityLocationService();

  @override
  Future<ProximityCheckResult> checkProximity({
    required double userLatitude,
    required double userLongitude,
    required double landmarkLatitude,
    required double landmarkLongitude,
  }) async {
    final permission = await Geolocator.checkPermission();
    final granted = permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;

    if (!granted) {
      return const ProximityCheckResult(
        permissionGranted: false,
        distanceMeters: 0,
      );
    }

    final distance = Geolocator.distanceBetween(
      userLatitude,
      userLongitude,
      landmarkLatitude,
      landmarkLongitude,
    );

    return ProximityCheckResult(
      permissionGranted: true,
      distanceMeters: distance.round(),
    );
  }
}