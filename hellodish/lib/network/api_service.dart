import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

import '../core/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _authToken;

  void setAuthToken(String token) {
    _authToken = token;
  }

  void clearAuthToken() {
    _authToken = null;
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  void _logRequest(String method, String url, [Map<String, dynamic>? body]) {
    developer.log(
      '\n┌─────────────────────────────────────────\n'
          '│ 📤 REQUEST\n'
          '│ $method → $url\n'
          '│ Headers: ${_headers.toString()}\n'
          '${body != null ? '│ Body: ${const JsonEncoder.withIndent('  ').convert(body)}\n' : ''}'
          '└─────────────────────────────────────────',
      name: 'ApiService',
    );
  }

  void _logResponse(String url, int statusCode, Map<String, dynamic> body) {
    final isSuccess = statusCode >= 200 && statusCode < 300;
    developer.log(
      '\n┌─────────────────────────────────────────\n'
          '│ ${isSuccess ? '✅' : '❌'} RESPONSE\n'
          '│ URL: $url\n'
          '│ Status: $statusCode\n'
          '│ Body: ${const JsonEncoder.withIndent('  ').convert(body)}\n'
          '└─────────────────────────────────────────',
      name: 'ApiService',
    );
  }

  void _logError(String url, Object error) {
    developer.log(
      '\n┌─────────────────────────────────────────\n'
          '│ 🔴 ERROR\n'
          '│ URL: $url\n'
          '│ Error: $error\n'
          '└─────────────────────────────────────────',
      name: 'ApiService',
      error: error,
    );
  }

  Future<Map<String, dynamic>> get(String path) async {
    final url = '${AppStrings.baseUrl}$path';
    _logRequest('GET', url);
    try {
      final uri = Uri.parse(url);
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 30));
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      _logResponse(url, response.statusCode, responseBody);
      return responseBody;
    } catch (e) {
      _logError(url, e);
      return {
        'status': 'error',
        'message': 'Network error occurred. Please try again.',
      };
    }
  }

  Future<Map<String, dynamic>> post(
      String path,
      Map<String, dynamic> data,
      ) async {
    final url = '${AppStrings.baseUrl}$path';
    _logRequest('POST', url, data);
    try {
      final uri = Uri.parse(url);
      final response = await http
          .post(uri, headers: _headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      _logResponse(url, response.statusCode, responseBody);
      return responseBody;
    } catch (e) {
      _logError(url, e);
      return {
        'status': 'error',
        'message': 'Network error occurred. Please try again.',
      };
    }
  }
}