import 'package:flutter/foundation.dart';
import 'package:nw_trails/core/models/badge_progress.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/models/route_plan.dart';
import 'package:nw_trails/core/repositories/checkin_repository.dart';
import 'package:nw_trails/core/repositories/landmark_repository.dart';
import 'package:nw_trails/core/repositories/route_repository.dart';
import 'package:nw_trails/core/services/location_service.dart';

enum CheckInStatus {
  success,
  permissionDenied,
  outOfRange,
  duplicate,
}

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
  })  : _landmarkRepository = landmarkRepository,
        _checkInRepository = checkInRepository,
        _routeRepository = routeRepository,
        _locationService = locationService {
    _landmarks = _landmarkRepository.getAll();
    _routes = _routeRepository.getAll();
    _refreshCheckInRecords();
  }

  final LandmarkRepository _landmarkRepository;
  final CheckInRepository _checkInRepository;
  final RouteRepository _routeRepository;
  final LocationService _locationService;

  late final List<Landmark> _landmarks;
  late final List<RoutePlan> _routes;

  List<CheckInRecord> _checkInRecords = <CheckInRecord>[];

  int _selectedTabIndex = 0;
  LandmarkCategory? _selectedCategory;
  String? _activeRouteId;

  int get selectedTabIndex => _selectedTabIndex;
  LandmarkCategory? get selectedCategory => _selectedCategory;
  String? get activeRouteId => _activeRouteId;

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

    if (_checkInRepository.hasCheckInForDate(
      landmarkId: landmarkId,
      date: now,
    )) {
      return const CheckInAttemptResult(
        status: CheckInStatus.duplicate,
        message: 'You already checked in at this landmark today.',
      );
    }

    final ProximityCheckResult proximity =
        await _locationService.checkProximity(landmarkId: landmarkId);

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

    _checkInRepository.add(
      CheckInRecord(
        landmarkId: landmarkId,
        checkedInAt: now,
        note: null,
      ),
    );
    _refreshCheckInRecords();
    notifyListeners();

    return CheckInAttemptResult(
      status: CheckInStatus.success,
      message: 'Check-in saved. ${badgeProgress.nextBadgeHint}',
    );
  }

  void _refreshCheckInRecords() {
    _checkInRecords = List<CheckInRecord>.from(_checkInRepository.getAll())
      ..sort((CheckInRecord a, CheckInRecord b) {
        return b.checkedInAt.compareTo(a.checkedInAt);
      });
  }
}
