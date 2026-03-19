import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';

class MockLocationService {
  final DeviceGeolocationService _locationService;
  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();

  StreamSubscription<Position>? _realLocationSub;
  Position? _lastPosition;
  bool _mockInjected = false;

  MockLocationService(this._locationService) {
    _locationService.getCurrentPosition().then(_emitReal).catchError((_) {});
    _realLocationSub = _locationService.stream.listen(
      _emitReal,
      onError: (_) {},
    );
  }

  Position? get lastKnownPosition => _lastPosition;

  Stream<Position> get stream => _controller.stream;

  Future<Position?> ensureCurrentPosition() async {
    if (_mockInjected) return _lastPosition;
    try {
      final Position position = await _locationService.getCurrentPosition();
      _emitReal(position);
      return position;
    } catch (_) {
      return _lastPosition;
    }
  }

  void _emitReal(Position position) {
    if (_mockInjected) return;
    _lastPosition = position;
    _controller.add(position);
  }

  void _emit(Position position) {
    _lastPosition = position;
    _controller.add(position);
  }

  void injectLocation(double latitude, double longitude) {
    _mockInjected = true;
    _emit(
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
