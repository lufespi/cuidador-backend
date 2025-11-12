import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  String? get token => _token;

  Map<String, String> _getHeaders({bool requiresAuth = false}) {
    if (requiresAuth && _token != null) {
      return ApiConstants.authHeaders(_token!);
    }
    return ApiConstants.headers;
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = false,
    Map<String, String>? queryParameters,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint')
          .replace(queryParameters: queryParameters);

      final response = await http
          .get(
            uri,
            headers: _getHeaders(requiresAuth: requiresAuth),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro ao fazer requisição GET: $e');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await http
          .post(
            uri,
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro ao fazer requisição POST: $e');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await http
          .put(
            uri,
            headers: _getHeaders(requiresAuth: requiresAuth),
            body: jsonEncode(body),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro ao fazer requisição PUT: $e');
    }
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    try {
      final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');

      final response = await http
          .delete(
            uri,
            headers: _getHeaders(requiresAuth: requiresAuth),
          )
          .timeout(ApiConstants.connectionTimeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Erro ao fazer requisição DELETE: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    try {
      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (statusCode >= 200 && statusCode < 300) {
        return data;
      } else {
        throw ApiException(
          data['message'] ?? data['error'] ?? 'Erro desconhecido',
          statusCode: statusCode,
          data: data,
        );
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Erro ao processar resposta do servidor',
        statusCode: statusCode,
      );
    }
  }
}
