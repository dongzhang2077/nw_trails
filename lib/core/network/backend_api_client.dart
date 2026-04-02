import 'dart:convert';
import 'dart:typed_data';

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

class BackendUserSummary {
  const BackendUserSummary({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.roles,
  });

  final String userId;
  final String username;
  final String displayName;
  final List<String> roles;
}

class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final BackendUserSummary user;
}

class BackendApiClient {
  BackendApiClient({required this.baseUrl, http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  factory BackendApiClient.fromEnvironment() {
    return BackendApiClient(baseUrl: ApiConfig.baseUrl);
  }

  final http.Client _httpClient;

  final String baseUrl;

  String? _accessToken;
  String? _refreshToken;

  bool get hasSession => _accessToken != null && _accessToken!.isNotEmpty;

  String? get refreshToken => _refreshToken;

  void clearSession() {
    _accessToken = null;
    _refreshToken = null;
  }

  Future<AuthSession> login({
    required String username,
    required String password,
  }) async {
    final http.Response response = await _send(
      method: 'POST',
      path: '/auth/login',
      body: <String, dynamic>{'username': username, 'password': password},
      includeAuthHeader: false,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toApiException(response);
    }

    final Map<String, dynamic> payload = _decodeObject(response.body);
    final AuthSession session = _toAuthSession(payload);
    _accessToken = session.accessToken;
    _refreshToken = session.refreshToken;
    return session;
  }

  Future<void> logout({required String refreshToken}) async {
    await _postJson(
      '/auth/logout',
      body: <String, dynamic>{'refreshToken': refreshToken},
    );
    clearSession();
  }

  Future<BackendUserSummary> fetchCurrentUser() async {
    final Map<String, dynamic> payload = await _getJson('/auth/me');
    return _toBackendUserSummary(payload);
  }

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
    final payload = await _getJson(
      '/checkins',
      query: <String, String>{'period': period},
    );
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
    List<String>? photoUrls,
  }) async {
    try {
      final payload = await _postJson(
        '/checkins',
        body: <String, dynamic>{
          'landmarkId': landmarkId,
          'latitude': latitude,
          'longitude': longitude,
          'note': note,
          'photoUrls': photoUrls,
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

  Future<String> uploadCheckInPhoto({
    required Uint8List bytes,
    required String fileName,
  }) async {
    await _ensureAuthenticated();

    http.StreamedResponse streamedResponse = await _sendMultipart(
      path: '/checkins/photos',
      fileFieldName: 'file',
      bytes: bytes,
      fileName: fileName,
      accessToken: _accessToken,
    );

    if (streamedResponse.statusCode == 401) {
      final bool refreshed = await _tryRefresh();
      if (!refreshed) {
        clearSession();
        throw const BackendApiException(
          statusCode: 401,
          code: 'UNAUTHORIZED',
          message: 'Session expired. Please log in again.',
        );
      }
      streamedResponse = await _sendMultipart(
        path: '/checkins/photos',
        fileFieldName: 'file',
        bytes: bytes,
        fileName: fileName,
        accessToken: _accessToken,
      );
    }

    final http.Response response = await http.Response.fromStream(
      streamedResponse,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw _toApiException(response);
    }

    final Map<String, dynamic> payload = _decodeObject(response.body);
    final String? photoUrl = _string(payload['photoUrl']);
    if (photoUrl == null || photoUrl.isEmpty) {
      throw const BackendApiException(
        statusCode: 500,
        code: 'INVALID_RESPONSE',
        message: 'Backend upload response is missing photoUrl.',
      );
    }

    return photoUrl;
  }

  Future<Uint8List> fetchCheckInPhotoBytes({required String photoUrl}) async {
    final String path = _resolveApiPath(photoUrl);
    final http.Response response = await _sendAuthorized(
      method: 'GET',
      path: path,
    );
    return response.bodyBytes;
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
        clearSession();
        throw const BackendApiException(
          statusCode: 401,
          code: 'UNAUTHORIZED',
          message: 'Session expired. Please log in again.',
        );
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
    if (_accessToken == null || _accessToken!.isEmpty) {
      throw const BackendApiException(
        statusCode: 401,
        code: 'UNAUTHORIZED',
        message: 'Authentication is required. Please log in.',
      );
    }
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

  Future<http.StreamedResponse> _sendMultipart({
    required String path,
    required String fileFieldName,
    required List<int> bytes,
    required String fileName,
    String? accessToken,
  }) {
    final Uri uri = Uri.parse('$baseUrl$path');
    final http.MultipartRequest request = http.MultipartRequest('POST', uri);
    if (accessToken != null && accessToken.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $accessToken';
    }
    request.files.add(
      http.MultipartFile.fromBytes(fileFieldName, bytes, filename: fileName),
    );
    return _httpClient.send(request);
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
    final String categoryRaw = (_string(map?['category']) ?? 'historic')
        .toLowerCase();
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
    final DateTime checkedInAt =
        DateTime.tryParse(rawTimestamp)?.toLocal() ?? DateTime.now();

    List<String> photoUrls = _readStringList(map?['photoUrls']);
    if (photoUrls.isEmpty) {
      final String? singlePhotoUrl = _string(map?['photoUrl']);
      if (singlePhotoUrl != null && singlePhotoUrl.isNotEmpty) {
        photoUrls = <String>[singlePhotoUrl];
      }
    }

    return CheckInRecord(
      landmarkId: _string(map?['landmarkId']) ?? '',
      checkedInAt: checkedInAt,
      note: _string(map?['note']),
      photoUrls: photoUrls,
    );
  }

  AuthSession _toAuthSession(Map<String, dynamic> payload) {
    final String accessToken = _string(payload['accessToken']) ?? '';
    final String refreshToken = _string(payload['refreshToken']) ?? '';
    final BackendUserSummary user = _toBackendUserSummary(payload['user']);

    if (accessToken.isEmpty || refreshToken.isEmpty || user.username.isEmpty) {
      throw const BackendApiException(
        statusCode: 500,
        code: 'INVALID_RESPONSE',
        message: 'Authentication response is missing required fields.',
      );
    }

    return AuthSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  BackendUserSummary _toBackendUserSummary(dynamic value) {
    final Map<String, dynamic>? map = _readMap(value);
    if (map == null) {
      return const BackendUserSummary(
        userId: '',
        username: '',
        displayName: '',
        roles: <String>[],
      );
    }

    return BackendUserSummary(
      userId: _string(map['userId']) ?? '',
      username: _string(map['username']) ?? '',
      displayName: _string(map['displayName']) ?? '',
      roles: _readStringList(map['roles']),
    );
  }

  List<String> _readStringList(dynamic value) {
    if (value is! List<dynamic>) {
      return <String>[];
    }
    return value
        .whereType<String>()
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);
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

  String _resolveApiPath(String pathOrUrl) {
    if (pathOrUrl.startsWith('/')) {
      return pathOrUrl;
    }

    final Uri uri = Uri.parse(pathOrUrl);
    final String path = uri.path;
    if (path.startsWith('/')) {
      return path;
    }

    return '/$path';
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
