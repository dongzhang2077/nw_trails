import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/core/constants/category_colors.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';

class NwTrailsMap extends StatefulWidget {
  const NwTrailsMap({
    super.key,
    required this.landmarks,
    this.selectedLandmarkId,
    this.onLandmarkTap,
  });

  final List<Landmark> landmarks;
  final String? selectedLandmarkId;
  final ValueChanged<Landmark>? onLandmarkTap;

  @override
  State<NwTrailsMap> createState() => _NwTrailsMapState();
}

class _NwTrailsMapState extends State<NwTrailsMap> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  PointAnnotation? _userMarker;
  StreamSubscription<geo.Position>? _locationSub;
  Uint8List? _markerImage;
  geo.Position? _pendingPosition;

  final Map<String, PointAnnotation> _landmarkAnnotations = {};
  final Map<String, String> _annotationIdToLandmarkId = {};
  final Map<(LandmarkCategory, bool), Uint8List> _pinImageCache = {};

  bool _joystickVisible = false;
  bool _creatingMarker = false;
  double? _simLat;
  double? _simLng;
  String _currentStyleUri = MapboxStyles.MAPBOX_STREETS;
  String? _mapLoadErrorMessage;
  bool _styleFallbackAttempted = false;

  final CameraOptions _initialCamera = CameraOptions(
    center: Point(coordinates: Position(-122.9110, 49.2057)),
    zoom: 13.0,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_locationSub == null) {
      final appState = AppScope.of(context);
      _locationSub = appState.locationStream.listen(_onPosition);
      final last = appState.lastKnownPosition;
      if (last != null) _onPosition(last);
    }
  }

  @override
  void didUpdateWidget(NwTrailsMap old) {
    super.didUpdateWidget(old);
    if (old.selectedLandmarkId != widget.selectedLandmarkId) {
      _updateSelection(old.selectedLandmarkId, widget.selectedLandmarkId);
    }
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    super.dispose();
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;
  }

  void _onStyleLoaded(StyleLoadedEventData _) {
    _prepareAnnotationsForStyle();
  }

  Future<void> _prepareAnnotationsForStyle() async {
    final MapboxMap? mapboxMap = _mapboxMap;
    if (mapboxMap == null) {
      return;
    }

    final PointAnnotationManager annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    annotationManager.addOnPointAnnotationClickListener(
      _LandmarkClickListener(_onAnnotationTap),
    );
    _annotationManager = annotationManager;
    _landmarkAnnotations.clear();
    _annotationIdToLandmarkId.clear();
    _userMarker = null;

    await _createLandmarkAnnotations();

    final geo.Position? seed = _pendingPosition;
    _pendingPosition = null;
    if (seed != null) {
      await _onPosition(seed);
    }

    if (!mounted || _mapLoadErrorMessage == null) {
      return;
    }
    setState(() {
      _mapLoadErrorMessage = null;
    });
  }

  void _onMapLoadError(MapLoadingErrorEventData event) {
    if (event.type == MapLoadErrorType.STYLE && !_styleFallbackAttempted) {
      _styleFallbackAttempted = true;
      _currentStyleUri = MapboxStyles.STANDARD;
      _mapboxMap?.loadStyleURI(_currentStyleUri);
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _mapLoadErrorMessage = event.message;
    });
  }

  void _onAnnotationTap(PointAnnotation annotation) {
    final landmarkId = _annotationIdToLandmarkId[annotation.id];
    if (landmarkId == null) return;
    final landmark = widget.landmarks
        .where((l) => l.id == landmarkId)
        .firstOrNull;
    if (landmark != null) widget.onLandmarkTap?.call(landmark);
  }

  Future<void> _createLandmarkAnnotations() async {
    final manager = _annotationManager;
    if (manager == null) return;

    for (final landmark in widget.landmarks) {
      final isSelected = landmark.id == widget.selectedLandmarkId;
      final image = await _pinImage(landmark.category, isSelected);
      final annotation = await manager.create(
        PointAnnotationOptions(
          geometry: landmark.point,
          image: image,
          iconSize: isSelected ? 1.4 : 1.0,
        ),
      );
      _landmarkAnnotations[landmark.id] = annotation;
      _annotationIdToLandmarkId[annotation.id] = landmark.id;
    }
  }

  Future<void> _updateSelection(String? oldId, String? newId) async {
    final manager = _annotationManager;
    if (manager == null) return;

    if (oldId != null) {
      final ann = _landmarkAnnotations[oldId];
      final landmark = widget.landmarks.where((l) => l.id == oldId).firstOrNull;
      if (ann != null && landmark != null) {
        ann.image = await _pinImage(landmark.category, false);
        ann.iconSize = 1.0;
        await manager.update(ann);
      }
    }

    if (newId != null) {
      final ann = _landmarkAnnotations[newId];
      final landmark = widget.landmarks.where((l) => l.id == newId).firstOrNull;
      if (ann != null && landmark != null) {
        ann.image = await _pinImage(landmark.category, true);
        ann.iconSize = 1.4;
        await manager.update(ann);
      }
    }
  }

  Future<Uint8List> _pinImage(LandmarkCategory category, bool selected) async {
    final key = (category, selected);
    if (_pinImageCache.containsKey(key)) return _pinImageCache[key]!;
    final image = await _buildPinImage(categoryColor(category), selected);
    _pinImageCache[key] = image;
    return image;
  }

  Future<Uint8List> _buildPinImage(Color color, bool isSelected) async {
    final double size = isSelected ? 42 : 30;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2 - 2.5,
      Paint()..color = color,
    );
    if (isSelected) {
      canvas.drawCircle(
        Offset(size / 2, size / 2),
        size / 5,
        Paint()..color = Colors.white,
      );
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
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
    AppScope.of(context).injectLocation(_simLat!, _simLng!);
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
    if (kIsWeb) {
      return Container(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.map_outlined,
                  size: 36,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 10),
                Text(
                  'Map preview is not available on web.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Use Android or iOS to view the interactive map.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      children: [
        MapWidget(
          cameraOptions: _initialCamera,
          styleUri: _currentStyleUri,
          onMapCreated: _onMapCreated,
          onStyleLoadedListener: _onStyleLoaded,
          onMapLoadErrorListener: _onMapLoadError,
        ),
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
        if (_mapLoadErrorMessage != null)
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Card(
              color: const Color(0xFF1F2933).withValues(alpha: 0.78),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'Map style warning: $_mapLoadErrorMessage',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _LandmarkClickListener extends OnPointAnnotationClickListener {
  _LandmarkClickListener(this.onTap);

  final void Function(PointAnnotation) onTap;

  @override
  bool onPointAnnotationClick(PointAnnotation annotation) {
    onTap(annotation);
    return true;
  }
}
