class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080/api/v1',
  );

  static const String username = String.fromEnvironment(
    'API_USERNAME',
    defaultValue: 'student01',
  );

  static const String password = String.fromEnvironment(
    'API_PASSWORD',
    defaultValue: 'Passw0rd!',
  );
}
