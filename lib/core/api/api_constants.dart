class ApiConstants {
  // Use 10.0.2.2 for Android Emulator connecting to local host
  // Use localhost for iOS simulator or web
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
}
