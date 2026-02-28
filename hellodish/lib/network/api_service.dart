import 'dart:convert';
import 'package:http/http.dart' as http;

import '../core/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // TODO: Set to false when API is ready
  static const bool _mockEnabled = true;

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

  Map<String, dynamic> _mockResponse(String path) {
    if (path.contains('/auth/login') || path.contains('/auth/resend-otp')) {
      return {
        'status': 'success',
        'message': 'OTP sent successfully',
        'data': {'otpId': 'mock_otp_id_123456'},
      };
    }
    if (path.contains('/auth/verify-otp')) {
      return {
        'status': 'success',
        'message': 'OTP verified successfully',
        'data': {'token': 'mock_token_123456'},
      };
    }
    if (path.contains('/auth/logout')) {
      return {'status': 'success', 'message': 'Logout successful'};
    }
    return {'status': 'success', 'message': 'OK'};
  }

  Future<Map<String, dynamic>> post(
      String path,
      Map<String, dynamic> data,
      ) async {
    if (_mockEnabled) {
      await Future.delayed(const Duration(milliseconds: 800));
      return _mockResponse(path);
    }

    try {
      final uri = Uri.parse('${AppStrings.baseUrl}$path');
      final response = await http
          .post(uri, headers: _headers, body: jsonEncode(data))
          .timeout(const Duration(seconds: 30));

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      return {
        'status': 'error',
        'message': 'Network error occurred. Please try again.',
      };
    }
  }
}