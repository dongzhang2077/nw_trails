import 'package:geolocator/geolocator.dart';

abstract class GeolocationService {
  Stream<Position> get stream;
  Future<Position> getCurrentPosition();
}
