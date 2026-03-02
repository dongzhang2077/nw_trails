import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';
import 'package:nw_trails/core/services/mock_geolocation_service.dart';

class NwTrailsMap extends StatefulWidget {
  const NwTrailsMap({super.key});

  @override
  State<NwTrailsMap> createState() => _NwTrailsMapState();
}

class _NwTrailsMapState extends State<NwTrailsMap> {
  final MockLocationService _geoService = MockLocationService(
    DeviceGeolocationService(),
  );

  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  PointAnnotation? _userMarker;
  StreamSubscription<geo.Position>? _locationSub;
  Uint8List? _markerImage;
  geo.Position? _pendingPosition;

  bool _joystickVisible = false;
  bool _creatingMarker = false;
  double? _simLat;
  double? _simLng;

  final CameraOptions _initialCamera = CameraOptions(
    center: Point(coordinates: Position(-122.9110, 49.2057)),
    zoom: 13.0,
  );

  @override
  void initState() {
    super.initState();
    _locationSub = _geoService.stream.listen(_onPosition);
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _geoService.dispose();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    final seed = _pendingPosition;
    _pendingPosition = null;
    if (seed != null) await _onPosition(seed);
  }

  Future<void> _onPosition(geo.Position position) async {
    _simLat = position.latitude;
    _simLng = position.longitude;

    final manager = _annotationManager;
    if (manager == null) {
      _pendingPosition = position;
      return;
    }

    final point = Point(
      coordinates: Position(position.longitude, position.latitude),
    );

    _markerImage ??= await _buildMarkerImage();

    if (_userMarker == null) {
      if (_creatingMarker) return;
      _creatingMarker = true;
      _userMarker = await manager.create(
        PointAnnotationOptions(
          geometry: point,
          image: _markerImage,
          iconSize: 2.0,
        ),
      );
      _creatingMarker = false;
      await _mapboxMap?.flyTo(
        CameraOptions(center: point, zoom: 15.0),
        MapAnimationOptions(duration: 800),
      );
    } else {
      _userMarker!.geometry = point;
      await manager.update(_userMarker!);
    }
  }

  Future<void> _zoom(double delta) async {
    final map = _mapboxMap;
    if (map == null) return;
    final state = await map.getCameraState();
    await map.easeTo(
      CameraOptions(zoom: state.zoom + delta),
      MapAnimationOptions(duration: 200),
    );
  }

  void _onJoystickMove(StickDragDetails details) {
    final lat = _simLat;
    final lng = _simLng;
    if (lat == null || lng == null) return;

    const speed = 0.00002;
    _simLat = lat - details.y * speed;
    _simLng = lng + details.x * speed;
    _geoService.injectLocation(_simLat!, _simLng!);
  }

  Future<Uint8List> _buildMarkerImage() async {
    const double size = 32;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      const Offset(size / 2, size / 2),
      size / 2 - 3,
      Paint()..color = const Color(0xFF1976D2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MapWidget(cameraOptions: _initialCamera, onMapCreated: _onMapCreated),
        Positioned(
          top: 12,
          right: 12,
          child: Column(
            spacing: 8,
            children: [
              FloatingActionButton.small(
                heroTag: 'joystick_toggle',
                onPressed: () =>
                    setState(() => _joystickVisible = !_joystickVisible),
                child: Icon(_joystickVisible ? Icons.close : Icons.gamepad),
              ),
              FloatingActionButton.small(
                heroTag: 'zoom_in',
                onPressed: () => _zoom(1),
                child: const Icon(Icons.add),
              ),
              FloatingActionButton.small(
                heroTag: 'zoom_out',
                onPressed: () => _zoom(-1),
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        if (_joystickVisible)
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: Joystick(
                mode: JoystickMode.all,
                listener: _onJoystickMove,
              ),
            ),
          ),
      ],
    );
  }
}
