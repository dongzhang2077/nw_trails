import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:nw_trails/core/models/checkin_record.dart';
import 'package:nw_trails/core/models/landmark.dart';
import 'package:nw_trails/core/models/landmark_category.dart';
import 'package:nw_trails/core/models/route_plan.dart';
import 'package:nw_trails/core/network/api_config.dart';

enum BackendCheckInStatus {
  success,
  duplicate,
  outOfRange,
  unauthorized,
  validationError,
  unknownError,
}

class BackendCheckInResult {
  const BackendCheckInResult({
    required this.status,
    required this.message,
    this.distanceMeters,
  });

  final BackendCheckInStatus status;
  final String message;
  final int? distanceMeters;
}

class BackendApiException implements Exception {
  const BackendApiException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details,
  });

  final int statusCode;
  final String code;
  final String message;
  final Map<String, dynamic>? details;

  @override
  String toString() {
    return 'BackendApiException(statusCode: $statusCode, code: $code, '
        'message: $message)';
  }
}

class BackendApiClient {
  BackendApiClient({
    required this.baseUrl,
    required this.username,
    required this.password,
    http.Client? httpClient,
  }) : _httpClient = httpClient ?? http.Client();

  factory BackendApiClient.fromEnvironment() {
    return BackendApiClient(
      baseUrl: ApiConfig.baseUrl,
      username: ApiConfig.username,
      password: ApiConfig.password,
    );
  }

  final http.Client _httpClient;

  final String baseUrl;
  final String username;
  final String password;

  String? _accessToken;
  String? _refreshToken;

  Future<List<Landmark>> fetchLandmarks() async {
    final payload = await _getJson('/landmarks');
    final items = _readList(payload, 'items');
    return items.map(_toLandmark).toList(growable: false);
  }

  Future<List<RoutePlan>> fetchRoutes({String? difficulty}) async {
    final query = <String, String>{
      if (difficulty != null && difficulty.isNotEmpty) 'difficulty': difficulty,
    };
    final payload = await _getJson('/routes', query: query);
    final items = _readList(payload, 'items');
    return items.map(_toRoutePlan).toList(growable: false);
  }

  Future<List<CheckInRecord>> fetchCheckIns({String period = 'ALL'}) async {
    final payload = await _getJson('/checkins', query: <String, String>{'period': period});
    final items = _readList(payload, 'items');
    return items.map(_toCheckInRecord).toList(growable: false);
  }

  Future<void> startRoute(String routeId) async {
    await _postJson('/routes/$routeId/start');
  }

  Future<BackendCheckInResult> createCheckIn({
    required String landmarkId,
    required double latitude,
    required double longitude,
    String? note,
  }) async {
    try {
      final payload = await _postJson(
        '/checkins',
        body: <String, dynamic>{
          'landmarkId': landmarkId,
          'latitude': latitude,
          'longitude': longitude,
          'note': note,
        },
      );

      return BackendCheckInResult(
        status: BackendCheckInStatus.success,
        message: _string(payload['message']) ?? 'Check-in saved.',
      );
    } on BackendApiException catch (error) {
      switch (error.code) {
        case 'DUPLICATE_CHECKIN':
          return BackendCheckInResult(
            status: BackendCheckInStatus.duplicate,
            message: error.message,
          );
        case 'OUT_OF_RANGE':
          final distance = _readDistance(error.details);
          return BackendCheckInResult(
            status: BackendCheckInStatus.outOfRange,
            message: error.message,
            distanceMeters: distance,
          );
        case 'UNAUTHORIZED':
        case 'FORBIDDEN':
          return BackendCheckInResult(
            status: BackendCheckInStatus.unauthorized,
            message: error.message,
          );
        case 'VALIDATION_ERROR':
        case 'INVALID_ROUTE_LANDMARKS':
          return BackendCheckInResult(
            status: BackendCheckInStatus.validationError,
            message: error.message,
          );
        default:
          return BackendCheckInResult(
            status: BackendCheckInStatus.unknownError,
            message: error.message,
          );
      }
    }
  }

  Future<Map<String, dynamic>> _getJson(
    String path, {
    Map<String, String>? query,
  }) async {
    final response = await _sendAuthorized(
      method: 'GET',
      path: path,
      query: query,
    );
    return _decodeObject(response.body);
  }

  Future<Map<String, dynamic>> _postJson(
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final response = await _sendAuthorized(
      method: 'POST',
      path: path,
      query: query,
      body: body,
    );
    if (response.body.isEmpty) {
      return <String, dynamic>{};
    }
    return _decodeObject(response.body);
  }

  Future<http.Response> _sendAuthorized({
    required String method,
    required String path,
    Map<String, String>? query,
    Object? body,
  }) async {
    await _ensureAuthenticated();

    http.Response response = await _send(
      method: method,
      path: path,
      query: query,
      body: body,
      accessToken: _accessToken,
    );

    if (response.statusCode == 401) {
      final bool refreshed = await _tryRefresh();
      if (!refreshed) {
        await _login();
      }
      response = await _send(
        method: method,
        path: path,
        query: query,
        body: body,
        accessToken: _accessToken,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toApiException(response);
    }

    return response;
  }

  Future<void> _ensureAuthenticated() async {
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      return;
    }
    await _login();
  }

  Future<void> _login() async {
    final response = await _send(
      method: 'POST',
      path: '/auth/login',
      body: <String, dynamic>{
        'username': username,
        'password': password,
      },
      includeAuthHeader: false,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toApiException(response);
    }

    final payload = _decodeObject(response.body);
    _accessToken = _string(payload['accessToken']);
    _refreshToken = _string(payload['refreshToken']);
  }

  Future<bool> _tryRefresh() async {
    final refreshToken = _refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    final response = await _send(
      method: 'POST',
      path: '/auth/refresh',
      body: <String, dynamic>{'refreshToken': refreshToken},
      includeAuthHeader: false,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      _accessToken = null;
      _refreshToken = null;
      return false;
    }

    final payload = _decodeObject(response.body);
    _accessToken = _string(payload['accessToken']);
    _refreshToken = _string(payload['refreshToken']);
    return true;
  }

  Future<http.Response> _send({
    required String method,
    required String path,
    Map<String, String>? query,
    Object? body,
    String? accessToken,
    bool includeAuthHeader = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (includeAuthHeader && accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    switch (method) {
      case 'GET':
        return _httpClient.get(uri, headers: headers);
      case 'POST':
        return _httpClient.post(
          uri,
          headers: headers,
          body: body == null ? null : jsonEncode(body),
        );
      default:
        throw ArgumentError('Unsupported HTTP method: $method');
    }
  }

  BackendApiException _toApiException(http.Response response) {
    final String fallbackMessage =
        'Backend request failed with status ${response.statusCode}.';

    if (response.body.isEmpty) {
      return BackendApiException(
        statusCode: response.statusCode,
        code: 'HTTP_${response.statusCode}',
        message: fallbackMessage,
      );
    }

    try {
      final payload = _decodeObject(response.body);
      return BackendApiException(
        statusCode: response.statusCode,
        code: _string(payload['code']) ?? 'HTTP_${response.statusCode}',
        message: _string(payload['message']) ?? fallbackMessage,
        details: _readMap(payload['details']),
      );
    } catch (_) {
      return BackendApiException(
        statusCode: response.statusCode,
        code: 'HTTP_${response.statusCode}',
        message: fallbackMessage,
      );
    }
  }

  Landmark _toLandmark(dynamic value) {
    final map = _readMap(value);
    final String categoryRaw =
        (_string(map?['category']) ?? 'historic').toLowerCase();
    final LandmarkCategory category = LandmarkCategory.values.firstWhere(
      (item) => item.name == categoryRaw,
      orElse: () => LandmarkCategory.historic,
    );

    final latitude = _double(map?['latitude']) ?? 0;
    final longitude = _double(map?['longitude']) ?? 0;

    return Landmark(
      id: _string(map?['id']) ?? '',
      name: _string(map?['name']) ?? 'Unknown landmark',
      category: category,
      address: _string(map?['address']) ?? '',
      description: _string(map?['description']) ?? '',
      point: Point(coordinates: Position(longitude, latitude)),
      imageUrl: _string(map?['imageUrl']) ?? '',
      rating: _double(map?['rating']) ?? 0,
    );
  }

  RoutePlan _toRoutePlan(dynamic value) {
    final map = _readMap(value);
    final List<dynamic> landmarkIdsRaw = _readList(map, 'landmarkIds');

    return RoutePlan(
      id: _string(map?['id']) ?? '',
      name: _string(map?['name']) ?? 'Unknown route',
      distanceKm: _double(map?['distanceKm']) ?? 0,
      durationMinutes: _int(map?['durationMinutes']) ?? 0,
      difficulty: _string(map?['difficulty']) ?? 'Unknown',
      landmarkIds: landmarkIdsRaw
          .map(_string)
          .whereType<String>()
          .toList(growable: false),
    );
  }

  CheckInRecord _toCheckInRecord(dynamic value) {
    final map = _readMap(value);
    final String rawTimestamp = _string(map?['checkedInAt']) ?? '';
    final DateTime checkedInAt = DateTime.tryParse(rawTimestamp)?.toLocal() ?? DateTime.now();

    return CheckInRecord(
      landmarkId: _string(map?['landmarkId']) ?? '',
      checkedInAt: checkedInAt,
      note: _string(map?['note']),
    );
  }

  List<dynamic> _readList(Map<String, dynamic>? map, String key) {
    final value = map?[key];
    if (value is List<dynamic>) {
      return value;
    }
    return <dynamic>[];
  }

  Map<String, dynamic>? _readMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return value.cast<String, dynamic>();
    }
    return null;
  }

  Map<String, dynamic> _decodeObject(String raw) {
    final decoded = jsonDecode(raw);
    final map = _readMap(decoded);
    if (map == null) {
      throw const FormatException('Response body is not a JSON object.');
    }
    return map;
  }

  int? _readDistance(Map<String, dynamic>? details) {
    final value = details?['distanceMeters'];
    return _int(value);
  }

  String? _string(dynamic value) {
    if (value is String) {
      return value;
    }
    return null;
  }

  double? _double(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  int? _int(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
