import 'package:flutter/material.dart';
import 'package:nw_trails/app/main_shell.dart';
import 'package:nw_trails/app/state/app_scope.dart';
import 'package:nw_trails/app/state/app_state.dart';
import 'package:nw_trails/core/constants/app_theme.dart';
import 'package:nw_trails/core/network/backend_api_client.dart';
import 'package:nw_trails/core/repositories/stub/stub_checkin_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_landmark_repository.dart';
import 'package:nw_trails/core/repositories/stub/stub_route_repository.dart';
import 'package:nw_trails/core/services/device_geolocation_service.dart';
import 'package:nw_trails/core/services/mock_geolocation_service.dart';
import 'package:nw_trails/core/services/proximity_location_service.dart';
import 'package:permission_handler/permission_handler.dart';

class NWTrailsApp extends StatefulWidget {
  const NWTrailsApp({super.key});

  @override
  State<NWTrailsApp> createState() => _NWTrailsAppState();
}

class _NWTrailsAppState extends State<NWTrailsApp> {
  static const bool _useBackend = bool.fromEnvironment(
    'USE_BACKEND',
    defaultValue: true,
  );

  late final AppState _appState = AppState(
    landmarkRepository: StubLandmarkRepository(),
    checkInRepository: StubCheckInRepository(),
    routeRepository: StubRouteRepository(),
    locationService: ProximityLocationService(),
    mockLocationService: MockLocationService(DeviceGeolocationService()),
    backendApiClient: _useBackend ? BackendApiClient.fromEnvironment() : null,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      notifier: _appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'NW Trails',
        theme: buildAppTheme(),
        home: const MainShell(),
      ),
    );
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (!mounted) {
      return;
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Location permission is required to show your position on the map.',
          ),
        ),
      );
    }
  }
}
