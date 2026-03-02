import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/core/services/abstract/geolocation_service.dart';

class DeviceGeolocationService implements GeolocationService {
  static const _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
  );

  @override
  Stream<Position> get stream {
    Position? last;
    return Geolocator.getPositionStream(
      locationSettings: _locationSettings,
    ).where((pos) {
      if (last != null &&
          pos.latitude == last!.latitude &&
          pos.longitude == last!.longitude) {
        return false;
      }
      last = pos;
      return true;
    });
  }

  @override
  Future<Position> getCurrentPosition() =>
      Geolocator.getCurrentPosition(locationSettings: _locationSettings);
}
