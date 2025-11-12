class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:5000/api/v1';
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authMe = '/auth/me';
  
  // User endpoints
  static const String userProfile = '/user/profile';
  static const String userPreferences = '/user/preferences';
  
  // Pain endpoints
  static const String pain = '/pain';
  static String painById(int id) => '/pain/$id';
  static const String painStatistics = '/pain/statistics';
  
  // Storage keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUserId = 'user_id';
  static const String storageKeyUserEmail = 'user_email';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  static Map<String, String> authHeaders(String token) => {
    ...headers,
    'Authorization': 'Bearer $token',
  };
}
