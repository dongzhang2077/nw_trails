import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/repositories/stub/stub_checkin_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_landmark_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_route_repository.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';
import 'package:nw_trails/core/services/location_service.dart';
import 'package:nw_trails/core/services/mock_geolocation_service.dart';

void main() {
  group('AppState awards metrics', () {
    late _FakeDeviceGeolocationService fakeGeolocation;
    late MockLocationService mockLocation;
    late StubCheckInRepository checkInRepository;
    late AppState appState;

    setUp(() {
      fakeGeolocation = _FakeDeviceGeolocationService(
        initialPosition: _samplePosition(),
      );
      mockLocation = MockLocationService(fakeGeolocation);
      checkInRepository = StubCheckInRepository();

      appState = AppState(
        landmarkRepository: StubLandmarkRepository(),
        checkInRepository: checkInRepository,
        routeRepository: StubRouteRepository(),
        locationService: const _FakeLocationService(),
        mockLocationService: mockLocation,
      );
    });

    tearDown(() async {
      appState.dispose();
      mockLocation.dispose();
      await fakeGeolocation.dispose();
    });

    test('returns expected total landmarks per category', () {
      expect(appState.totalCountForCategory(LandmarkCategory.historic), 4);
      expect(appState.totalCountForCategory(LandmarkCategory.nature), 4);
      expect(appState.totalCountForCategory(LandmarkCategory.food), 3);
      expect(appState.totalCountForCategory(LandmarkCategory.culture), 4);
    });

    test(
      'counts visited landmarks by unique ids for badge and category progress',
      () {
        checkInRepository
          ..add(
            CheckInRecord(
              landmarkId: 'l1',
              checkedInAt: DateTime(2026, 3, 1, 8),
              note: null,
            ),
          )
          ..add(
            CheckInRecord(
              landmarkId: 'l1',
              checkedInAt: DateTime(2026, 3, 2, 8),
              note: null,
            ),
          )
          ..add(
            CheckInRecord(
              landmarkId: 'l5',
              checkedInAt: DateTime(2026, 3, 2, 9),
              note: null,
            ),
          )
          ..add(
            CheckInRecord(
              landmarkId: 'l12',
              checkedInAt: DateTime(2026, 3, 2, 10),
              note: null,
            ),
          );

        appState.dispose();
        appState = AppState(
          landmarkRepository: StubLandmarkRepository(),
          checkInRepository: checkInRepository,
          routeRepository: StubRouteRepository(),
          locationService: const _FakeLocationService(),
          mockLocationService: mockLocation,
        );

        expect(appState.badgeProgress.visitedCount, 3);
        expect(appState.badgeProgress.nextBadgeHint, 'Next badge: Bronze (5)');

        expect(appState.visitedCountForCategory(LandmarkCategory.historic), 1);
        expect(appState.visitedCountForCategory(LandmarkCategory.nature), 1);
        expect(appState.visitedCountForCategory(LandmarkCategory.culture), 1);
        expect(appState.visitedCountForCategory(LandmarkCategory.food), 0);
      },
    );
  });
}

class _FakeLocationService implements LocationService {
  const _FakeLocationService();

  @override
  Future<ProximityCheckResult> checkProximity({
    required double userLatitude,
    required double userLongitude,
    required double landmarkLatitude,
    required double landmarkLongitude,
  }) async {
    return const ProximityCheckResult(
      permissionGranted: true,
      distanceMeters: 0,
    );
  }
}

class _FakeDeviceGeolocationService extends DeviceGeolocationService {
  _FakeDeviceGeolocationService({required Position initialPosition})
    : _currentPosition = initialPosition;

  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();
  final Position _currentPosition;

  @override
  Stream<Position> get stream => _controller.stream;

  @override
  Future<Position> getCurrentPosition() async => _currentPosition;

  Future<void> dispose() async {
    await _controller.close();
  }
}

Position _samplePosition() {
  return Position(
    latitude: 49.2064,
    longitude: -122.9094,
    timestamp: DateTime(2026, 3, 2, 8),
    accuracy: 1,
    altitude: 0,
    altitudeAccuracy: 1,
    heading: 0,
    headingAccuracy: 1,
    speed: 0,
    speedAccuracy: 1,
  );
}
