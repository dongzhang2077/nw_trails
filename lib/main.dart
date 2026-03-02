import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const String mapboxToken = String.fromEnvironment('MAPBOX_ACCESS_TOKEN');
  if (!kIsWeb && mapboxToken.isNotEmpty) {
    MapboxOptions.setAccessToken(mapboxToken);
  }

  runApp(const NWTrailsApp());
}
