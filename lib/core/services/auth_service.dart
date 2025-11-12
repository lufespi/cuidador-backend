import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import 'api_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _apiService = ApiService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null && _apiService.token != null;

  /// Registrar novo usuário
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String phone,
    required String gender,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.authRegister,
        body: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'birth_date': birthDate,
          'phone': phone,
          'gender': gender,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response);
      
      // Salvar token e dados do usuário
      await _saveAuthData(authResponse.token, authResponse.user);
      
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Fazer login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.authLogin,
        body: {
          'email': email,
          'password': password,
        },
      );

      final authResponse = AuthResponseModel.fromJson(response);
      
      // Salvar token e dados do usuário
      await _saveAuthData(authResponse.token, authResponse.user);
      
      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  /// Buscar dados do usuário atual
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiService.get(
        ApiConstants.authMe,
        requiresAuth: true,
      );

      _currentUser = UserModel.fromJson(response['user']);
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }

  /// Fazer logout
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(ApiConstants.storageKeyToken);
      await prefs.remove(ApiConstants.storageKeyUserId);
      await prefs.remove(ApiConstants.storageKeyUserEmail);
      
      _apiService.setToken(null);
      _currentUser = null;
    } catch (e) {
      rethrow;
    }
  }

  /// Verificar se há sessão salva e restaurar
  Future<bool> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(ApiConstants.storageKeyToken);
      
      if (token != null) {
        _apiService.setToken(token);
        
        // Tentar buscar dados do usuário
        try {
          await getCurrentUser();
          return true;
        } catch (e) {
          // Token inválido ou expirado
          await logout();
          return false;
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Salvar dados de autenticação no storage
  Future<void> _saveAuthData(String token, Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(ApiConstants.storageKeyToken, token);
      await prefs.setInt(ApiConstants.storageKeyUserId, userData['id']);
      await prefs.setString(ApiConstants.storageKeyUserEmail, userData['email']);
      
      _apiService.setToken(token);
      _currentUser = UserModel.fromJson(userData);
    } catch (e) {
      rethrow;
    }
  }

  /// Atualizar perfil do usuário
  Future<UserModel> updateProfile({
    String? firstName,
    String? lastName,
    String? birthDate,
    String? phone,
    String? gender,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (firstName != null) body['first_name'] = firstName;
      if (lastName != null) body['last_name'] = lastName;
      if (birthDate != null) body['birth_date'] = birthDate;
      if (phone != null) body['phone'] = phone;
      if (gender != null) body['gender'] = gender;

      final response = await _apiService.put(
        ApiConstants.userProfile,
        body: body,
        requiresAuth: true,
      );

      _currentUser = UserModel.fromJson(response['user']);
      return _currentUser!;
    } catch (e) {
      rethrow;
    }
  }

  /// Atualizar preferências do usuário
  Future<Map<String, dynamic>> updatePreferences({
    Map<String, dynamic>? notificationSettings,
    Map<String, dynamic>? privacySettings,
    String? theme,
    String? language,
  }) async {
    try {
      final body = <String, dynamic>{};
      
      if (notificationSettings != null) body['notification_settings'] = notificationSettings;
      if (privacySettings != null) body['privacy_settings'] = privacySettings;
      if (theme != null) body['theme'] = theme;
      if (language != null) body['language'] = language;

      final response = await _apiService.put(
        ApiConstants.userPreferences,
        body: body,
        requiresAuth: true,
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
