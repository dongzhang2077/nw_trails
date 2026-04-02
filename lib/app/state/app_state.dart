import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:nw_trails/core/models/badge_progress.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/models/route_plan.dart';
import 'package:nw_trails/core/network/backend_api_client.dart';
import 'package:nw_trails/core/repositories/checkin_repository.dart';
import 'package:nw_trails/core/repositories/landmark_repository.dart';
import 'package:nw_trails/core/repositories/route_repository.dart';
import 'package:nw_trails/core/services/location_service.dart';
import 'package:nw_trails/core/services/mock_geolocation_service.dart';

enum CheckInStatus { success, permissionDenied, outOfRange, duplicate }

class CheckInAttemptResult {
  const CheckInAttemptResult({
    required this.status,
    required this.message,
    this.distanceMeters,
  });

  final CheckInStatus status;
  final String message;
  final int? distanceMeters;
}

class AppState extends ChangeNotifier {
  AppState({
    required LandmarkRepository landmarkRepository,
    required CheckInRepository checkInRepository,
    required RouteRepository routeRepository,
    required LocationService locationService,
    required MockLocationService mockLocationService,
    BackendApiClient? backendApiClient,
  }) : _landmarkRepository = landmarkRepository,
       _checkInRepository = checkInRepository,
       _routeRepository = routeRepository,
       _locationService = locationService,
       _mockLocationService = mockLocationService,
       _backendApiClient = backendApiClient {
    _landmarks = _landmarkRepository.getAll();
    _routes = _routeRepository.getAll();
    _refreshCheckInRecords();
    unawaited(_initializeBackendSync());
  }

  final LandmarkRepository _landmarkRepository;
  final CheckInRepository _checkInRepository;
  final RouteRepository _routeRepository;
  final LocationService _locationService;
  final MockLocationService _mockLocationService;
  final BackendApiClient? _backendApiClient;

  List<Landmark> _landmarks = <Landmark>[];
  List<RoutePlan> _routes = <RoutePlan>[];

  List<CheckInRecord> _checkInRecords = <CheckInRecord>[];
  bool _isSyncingBackend = false;
  String? _syncError;

  int _selectedTabIndex = 0;
  LandmarkCategory? _selectedCategory;
  String? _activeRouteId;

  Stream<geo.Position> get locationStream => _mockLocationService.stream;
  geo.Position? get lastKnownPosition => _mockLocationService.lastKnownPosition;
  bool get usingInjectedLocation => _mockLocationService.usingInjectedLocation;

  void injectLocation(double lat, double lng) =>
      _mockLocationService.injectLocation(lat, lng);

  Future<geo.Position?> useDeviceLocation() async {
    return _mockLocationService.useDeviceLocation();
  }

  int get selectedTabIndex => _selectedTabIndex;
  LandmarkCategory? get selectedCategory => _selectedCategory;
  String? get activeRouteId => _activeRouteId;
  bool get isSyncingBackend => _isSyncingBackend;
  String? get syncError => _syncError;
  bool get usingBackend => _backendApiClient != null;

  List<Landmark> get landmarks => List<Landmark>.unmodifiable(_landmarks);
  List<RoutePlan> get routes => List<RoutePlan>.unmodifiable(_routes);

  List<CheckInRecord> get checkInRecords =>
      List<CheckInRecord>.unmodifiable(_checkInRecords);

  RoutePlan? get activeRoute {
    if (_activeRouteId == null) {
      return null;
    }
    return findRouteById(_activeRouteId!);
  }

  List<Landmark> get filteredLandmarks {
    final category = _selectedCategory;
    if (category == null) {
      return List<Landmark>.unmodifiable(_landmarks);
    }
    return _landmarks
        .where((Landmark item) => item.category == category)
        .toList(growable: false);
  }

  Set<String> get _visitedLandmarkIds =>
      _checkInRecords.map((CheckInRecord item) => item.landmarkId).toSet();

  BadgeProgress get badgeProgress => BadgeProgress(
    visitedCount: _visitedLandmarkIds.length,
    totalLandmarks: _landmarks.length,
  );

  bool hasVisitedLandmark(String landmarkId) {
    return _visitedLandmarkIds.contains(landmarkId);
  }

  int completedStopCountForRoute(RoutePlan route) {
    final Set<String> visitedIds = _visitedLandmarkIds;
    return route.landmarkIds.where(visitedIds.contains).length;
  }

  String? nextUnvisitedLandmarkIdForRoute(String routeId) {
    final RoutePlan? route = findRouteById(routeId);
    if (route == null) {
      return null;
    }

    final Set<String> visitedIds = _visitedLandmarkIds;
    for (final String landmarkId in route.landmarkIds) {
      if (!visitedIds.contains(landmarkId)) {
        return landmarkId;
      }
    }
    return null;
  }

  int visitedCountForCategory(LandmarkCategory category) {
    final visitedIds = _visitedLandmarkIds;
    return _landmarks.where((Landmark item) {
      return item.category == category && visitedIds.contains(item.id);
    }).length;
  }

  int totalCountForCategory(LandmarkCategory category) {
    return _landmarks
        .where((Landmark item) => item.category == category)
        .length;
  }

  void setSelectedTabIndex(int index) {
    if (_selectedTabIndex == index) {
      return;
    }
    _selectedTabIndex = index;
    notifyListeners();
  }

  void setCategory(LandmarkCategory? category) {
    if (_selectedCategory == category) {
      return;
    }
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> retryBackendSync() async {
    await _syncFromBackend();
  }

  Landmark? findLandmarkById(String landmarkId) {
    for (final Landmark landmark in _landmarks) {
      if (landmark.id == landmarkId) {
        return landmark;
      }
    }
    return null;
  }

  RoutePlan? findRouteById(String routeId) {
    for (final RoutePlan route in _routes) {
      if (route.id == routeId) {
        return route;
      }
    }
    return null;
  }

  String landmarkNameById(String landmarkId) {
    return findLandmarkById(landmarkId)?.name ?? landmarkId;
  }

  void startRoute(String routeId) {
    _activeRouteId = routeId;
    final backendApiClient = _backendApiClient;
    if (backendApiClient != null) {
      unawaited(backendApiClient.startRoute(routeId));
    }
    notifyListeners();
  }

  void clearActiveRoute() {
    if (_activeRouteId == null) {
      return;
    }
    _activeRouteId = null;
    notifyListeners();
  }

  Future<CheckInAttemptResult> attemptCheckIn(String landmarkId) async {
    final DateTime now = DateTime.now();

    if (_backendApiClient == null &&
        _checkInRepository.hasCheckInForDate(landmarkId: landmarkId, date: now)) {
      return const CheckInAttemptResult(
        status: CheckInStatus.duplicate,
        message: 'You already checked in at this landmark today.',
      );
    }

    final Landmark? targetLandmark = findLandmarkById(landmarkId);
    if (targetLandmark == null) {
      return const CheckInAttemptResult(
        status: CheckInStatus.outOfRange,
        message: 'Landmark location is unavailable for check-in.',
      );
    }

    final geo.Position? lastPosition = await _mockLocationService
        .ensureCurrentPosition();
    if (lastPosition == null) {
      return const CheckInAttemptResult(
        status: CheckInStatus.permissionDenied,
        message: 'Location permission is required for check-in.',
      );
    }

    final ProximityCheckResult proximity = await _locationService
        .checkProximity(
          userLatitude: lastPosition.latitude,
          userLongitude: lastPosition.longitude,
          landmarkLatitude: targetLandmark.point.coordinates.lat.toDouble(),
          landmarkLongitude: targetLandmark.point.coordinates.lng.toDouble(),
        );

    if (!proximity.permissionGranted) {
      return const CheckInAttemptResult(
        status: CheckInStatus.permissionDenied,
        message: 'Location permission is required for check-in.',
      );
    }

    if (proximity.distanceMeters > 50) {
      return CheckInAttemptResult(
        status: CheckInStatus.outOfRange,
        message: 'Move closer to this landmark before checking in.',
        distanceMeters: proximity.distanceMeters,
      );
    }

    final backendApiClient = _backendApiClient;
    if (backendApiClient != null) {
      final BackendCheckInResult backendResult = await backendApiClient
          .createCheckIn(
            landmarkId: landmarkId,
            latitude: lastPosition.latitude,
            longitude: lastPosition.longitude,
            note: null,
          );

      switch (backendResult.status) {
        case BackendCheckInStatus.success:
          await _refreshCheckInRecordsFromBackend();
          final String routeMessage = _buildRouteProgressMessageAfterCheckIn(
            landmarkId: landmarkId,
          );
          notifyListeners();
          return CheckInAttemptResult(
            status: CheckInStatus.success,
            message: backendResult.message.isEmpty
                ? 'Check-in saved. ${badgeProgress.nextBadgeHint}$routeMessage'
                : backendResult.message,
          );
        case BackendCheckInStatus.duplicate:
          return CheckInAttemptResult(
            status: CheckInStatus.duplicate,
            message: backendResult.message,
          );
        case BackendCheckInStatus.outOfRange:
          return CheckInAttemptResult(
            status: CheckInStatus.outOfRange,
            message: backendResult.message,
            distanceMeters: backendResult.distanceMeters,
          );
        case BackendCheckInStatus.unauthorized:
          return CheckInAttemptResult(
            status: CheckInStatus.permissionDenied,
            message: backendResult.message,
          );
        case BackendCheckInStatus.validationError:
        case BackendCheckInStatus.unknownError:
          return CheckInAttemptResult(
            status: CheckInStatus.outOfRange,
            message: backendResult.message,
          );
      }
    }

    _checkInRepository.add(
      CheckInRecord(landmarkId: landmarkId, checkedInAt: now, note: null),
    );
    _refreshCheckInRecords();

    final String routeMessage = _buildRouteProgressMessageAfterCheckIn(
      landmarkId: landmarkId,
    );

    notifyListeners();

    return CheckInAttemptResult(
      status: CheckInStatus.success,
      message: 'Check-in saved. ${badgeProgress.nextBadgeHint}$routeMessage',
    );
  }

  Future<void> _initializeBackendSync() async {
    if (_backendApiClient == null) {
      return;
    }
    await _syncFromBackend();
  }

  Future<void> _syncFromBackend() async {
    final backendApiClient = _backendApiClient;
    if (backendApiClient == null) {
      return;
    }

    _isSyncingBackend = true;
    _syncError = null;
    notifyListeners();

    try {
      final List<Landmark> landmarks = await backendApiClient.fetchLandmarks();
      final List<RoutePlan> routes = await backendApiClient.fetchRoutes();
      final List<CheckInRecord> checkIns = await backendApiClient
          .fetchCheckIns();

      _landmarks = landmarks;
      _routes = routes;
      _setCheckInRecords(checkIns);
    } catch (error) {
      _syncError =
          'Backend sync failed. Check API_BASE_URL / credentials and retry.';
    } finally {
      _isSyncingBackend = false;
      notifyListeners();
    }
  }

  Future<void> _refreshCheckInRecordsFromBackend() async {
    final backendApiClient = _backendApiClient;
    if (backendApiClient == null) {
      return;
    }
    final List<CheckInRecord> checkIns = await backendApiClient.fetchCheckIns();
    _setCheckInRecords(checkIns);
  }

  String _buildRouteProgressMessageAfterCheckIn({required String landmarkId}) {
    final String? activeRouteId = _activeRouteId;
    if (activeRouteId == null) {
      return '';
    }

    final RoutePlan? route = findRouteById(activeRouteId);
    if (route == null || !route.landmarkIds.contains(landmarkId)) {
      return '';
    }

    final int completedStops = completedStopCountForRoute(route);
    final String? nextStopId = nextUnvisitedLandmarkIdForRoute(route.id);

    if (nextStopId == null) {
      _activeRouteId = null;
      return '\n\nRoute completed: ${route.name}.';
    }

    return '\n\nRoute progress: '
        '$completedStops/${route.landmarkIds.length} stops. '
        'Next stop: ${landmarkNameById(nextStopId)}.';
  }

  void _refreshCheckInRecords() {
    _setCheckInRecords(_checkInRepository.getAll());
  }

  void _setCheckInRecords(List<CheckInRecord> records) {
    _checkInRecords = List<CheckInRecord>.from(records)
      ..sort((CheckInRecord a, CheckInRecord b) {
        return b.checkedInAt.compareTo(a.checkedInAt);
      });
  }
}
