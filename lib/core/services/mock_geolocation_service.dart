import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';

class MockLocationService {
  final DeviceGeolocationService _locationService;
  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();

  StreamSubscription<Position>? _realLocationSub;

  MockLocationService(this._locationService) {
    _locationService
        .getCurrentPosition()
        .then(_controller.add)
        .catchError((_) {});
    _realLocationSub = _locationService.stream.listen(
      _controller.add,
      onError: _controller.addError,
    );
  }

  Stream<Position> get stream => _controller.stream;

  void injectLocation(double latitude, double longitude) {
    _controller.add(
      Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        altitudeAccuracy: 0,
        heading: 0,
        headingAccuracy: 0,
        speed: 0,
        speedAccuracy: 0,
      ),
    );
  }

  void dispose() {
    _realLocationSub?.cancel();
    _controller.close();
  }
}
