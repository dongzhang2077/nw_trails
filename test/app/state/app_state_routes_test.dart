import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/repositories/stub/stub_checkin_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_landmark_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_route_repository.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';
import 'package:nw_trails/core/services/location_service.dart';
import 'package:nw_trails/core/services/mock_geolocation_service.dart';

void main() {
  group('AppState route helpers', () {
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
        locationService: const _FakeLocationService(
          ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
        ),
        mockLocationService: mockLocation,
      );
    });

    tearDown(() async {
      appState.dispose();
      mockLocation.dispose();
      await fakeGeolocation.dispose();
    });

    test('computes next stop and completed count from check-in records', () {
      checkInRepository.add(
        CheckInRecord(
          landmarkId: 'l1',
          checkedInAt: DateTime(2026, 3, 2, 9),
          note: null,
        ),
      );
      checkInRepository.add(
        CheckInRecord(
          landmarkId: 'l2',
          checkedInAt: DateTime(2026, 3, 2, 10),
          note: null,
        ),
      );

      appState = AppState(
        landmarkRepository: StubLandmarkRepository(),
        checkInRepository: checkInRepository,
        routeRepository: StubRouteRepository(),
        locationService: const _FakeLocationService(
          ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
        ),
        mockLocationService: mockLocation,
      );

      final route = appState.findRouteById('r1');
      expect(route, isNotNull);
      expect(appState.completedStopCountForRoute(route!), 2);
      expect(appState.nextUnvisitedLandmarkIdForRoute(route.id), 'l3');
      expect(appState.hasVisitedLandmark('l1'), isTrue);
      expect(appState.hasVisitedLandmark('l3'), isFalse);
    });

    test('returns null next stop when route is fully completed', () {
      final route = appState.findRouteById('r3');
      expect(route, isNotNull);

      for (final landmarkId in route!.landmarkIds) {
        checkInRepository.add(
          CheckInRecord(
            landmarkId: landmarkId,
            checkedInAt: DateTime(2026, 3, 2, 11),
            note: null,
          ),
        );
      }

      appState = AppState(
        landmarkRepository: StubLandmarkRepository(),
        checkInRepository: checkInRepository,
        routeRepository: StubRouteRepository(),
        locationService: const _FakeLocationService(
          ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
        ),
        mockLocationService: mockLocation,
      );

      expect(
        appState.completedStopCountForRoute(route),
        route.landmarkIds.length,
      );
      expect(appState.nextUnvisitedLandmarkIdForRoute(route.id), isNull);
    });

    test('returns null for unknown route id', () {
      expect(appState.nextUnvisitedLandmarkIdForRoute('unknown'), isNull);
    });

    test('adds route progress hint when checking in on active route', () async {
      appState.startRoute('r1');
      appState.injectLocation(49.2064, -122.9094);

      final CheckInAttemptResult result = await appState.attemptCheckIn('l1');

      expect(result.status, CheckInStatus.success);
      expect(result.message, contains('Route progress: 1/5 stops.'));
      expect(result.message, contains('Next stop: New Westminster Museum.'));
      expect(appState.activeRouteId, 'r1');
    });

    test(
      'does not advance route when check-in landmark is outside active route',
      () async {
        appState.startRoute('r1');
        appState.injectLocation(49.2028, -122.9121);

        final CheckInAttemptResult result = await appState.attemptCheckIn('l9');

        expect(result.status, CheckInStatus.success);
        expect(result.message, isNot(contains('Route progress:')));
        expect(appState.activeRouteId, 'r1');
        expect(appState.nextUnvisitedLandmarkIdForRoute('r1'), 'l1');
      },
    );

    test('clears active route when final stop is checked in', () async {
      checkInRepository.add(
        CheckInRecord(
          landmarkId: 'l9',
          checkedInAt: DateTime(2026, 3, 2, 8, 0),
          note: null,
        ),
      );
      checkInRepository.add(
        CheckInRecord(
          landmarkId: 'l10',
          checkedInAt: DateTime(2026, 3, 2, 8, 30),
          note: null,
        ),
      );
      checkInRepository.add(
        CheckInRecord(
          landmarkId: 'l11',
          checkedInAt: DateTime(2026, 3, 2, 9, 0),
          note: null,
        ),
      );

      appState.dispose();
      appState = AppState(
        landmarkRepository: StubLandmarkRepository(),
        checkInRepository: checkInRepository,
        routeRepository: StubRouteRepository(),
        locationService: const _FakeLocationService(
          ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
        ),
        mockLocationService: mockLocation,
      );

      appState.startRoute('r3');
      appState.injectLocation(49.2071, -122.9115);

      final CheckInAttemptResult result = await appState.attemptCheckIn('l14');

      expect(result.status, CheckInStatus.success);
      expect(
        result.message,
        contains('Route completed: Food and Market Tour.'),
      );
      expect(appState.activeRouteId, isNull);
    });

    test(
      'returns permission denied when current position is unavailable',
      () async {
        appState.dispose();
        mockLocation.dispose();
        await fakeGeolocation.dispose();

        fakeGeolocation = _FakeDeviceGeolocationService(
          initialPosition: _samplePosition(),
          throwOnGetCurrentPosition: true,
        );
        mockLocation = MockLocationService(fakeGeolocation);

        appState = AppState(
          landmarkRepository: StubLandmarkRepository(),
          checkInRepository: StubCheckInRepository(),
          routeRepository: StubRouteRepository(),
          locationService: const _FakeLocationService(
            ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
          ),
          mockLocationService: mockLocation,
        );

        final CheckInAttemptResult result = await appState.attemptCheckIn('l1');

        expect(result.status, CheckInStatus.permissionDenied);
        expect(result.message, 'Location permission is required for check-in.');
      },
    );

    test(
      'uses latest getCurrentPosition even with stale cached stream value',
      () async {
        appState.dispose();
        mockLocation.dispose();
        await fakeGeolocation.dispose();

        fakeGeolocation = _FakeDeviceGeolocationService(
          initialPosition: _position(latitude: 49.3000, longitude: -123.1000),
        );
        mockLocation = MockLocationService(fakeGeolocation);
        appState = AppState(
          landmarkRepository: StubLandmarkRepository(),
          checkInRepository: StubCheckInRepository(),
          routeRepository: StubRouteRepository(),
          locationService: const _FakeLocationService(
            ProximityCheckResult(permissionGranted: true, distanceMeters: 0),
          ),
          mockLocationService: mockLocation,
        );

        fakeGeolocation.setCurrentPositionWithoutStream(
          _position(latitude: 49.2064, longitude: -122.9094),
        );

        final CheckInAttemptResult result = await appState.attemptCheckIn('l1');

        expect(result.status, CheckInStatus.success);
      },
    );
  });
}

class _FakeLocationService implements LocationService {
  const _FakeLocationService(this._result);

  final ProximityCheckResult _result;

  @override
  Future<ProximityCheckResult> checkProximity({
    required double userLatitude,
    required double userLongitude,
    required double landmarkLatitude,
    required double landmarkLongitude,
  }) async {
    return _result;
  }
}

class _FakeDeviceGeolocationService extends DeviceGeolocationService {
  _FakeDeviceGeolocationService({
    required Position initialPosition,
    this.throwOnGetCurrentPosition = false,
  }) : _currentPosition = initialPosition;

  final StreamController<Position> _controller =
      StreamController<Position>.broadcast();
  Position _currentPosition;
  final bool throwOnGetCurrentPosition;

  @override
  Stream<Position> get stream => _controller.stream;

  @override
  Future<Position> getCurrentPosition() async {
    if (throwOnGetCurrentPosition) {
      throw Exception('Location unavailable');
    }
    return _currentPosition;
  }

  void emit(Position position) {
    _currentPosition = position;
    _controller.add(position);
  }

  void setCurrentPositionWithoutStream(Position position) {
    _currentPosition = position;
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}

Position _samplePosition() {
  return _position(latitude: 49.2064, longitude: -122.9094);
}

Position _position({required double latitude, required double longitude}) {
  return Position(
    latitude: latitude,
    longitude: longitude,
    timestamp: DateTime(2026, 3, 2, 8, 0),
    accuracy: 1,
    altitude: 0,
    altitudeAccuracy: 1,
    heading: 0,
    headingAccuracy: 1,
    speed: 0,
    speedAccuracy: 1,
  );
}
