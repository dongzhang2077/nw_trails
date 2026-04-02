import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';

class MockLocationService {
  final DeviceGeolocationService _locationService;
  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();

  StreamSubscription<Position>? _realLocationSub;
  Position? _lastPosition;
  bool _useInjectedLocation = false;

  MockLocationService(this._locationService) {
    _locationService
        .getCurrentPosition()
        .then(_emitDevicePosition)
        .catchError((_) {});
    _realLocationSub = _locationService.stream.listen(
      _emitDevicePosition,
      onError: (_) {},
    );
  }

  Position? get lastKnownPosition => _lastPosition;

  bool get usingInjectedLocation => _useInjectedLocation;

  Stream<Position> get stream => _controller.stream;

  Future<Position?> ensureCurrentPosition() async {
    if (_useInjectedLocation && _lastPosition != null) {
      return _lastPosition;
    }

    try {
      final Position position = await _locationService.getCurrentPosition();
      _emitDevicePosition(position);
      return _lastPosition;
    } catch (_) {
      return _lastPosition;
    }
  }

  void _emitDevicePosition(Position position) {
    if (_useInjectedLocation) {
      return;
    }
    _emit(position);
  }

  void _emit(Position position) {
    _lastPosition = position;
    _controller.add(position);
  }

  void injectLocation(double latitude, double longitude) {
    _useInjectedLocation = true;
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

  Future<Position?> useDeviceLocation() async {
    _useInjectedLocation = false;
    try {
      final Position position = await _locationService.getCurrentPosition();
      _emitDevicePosition(position);
      return _lastPosition;
    } catch (_) {
      // Keep last known location if device position is unavailable.
      return _lastPosition;
    }
  }

  void dispose() {
    _realLocationSub?.cancel();
    _controller.close();
  }
}
