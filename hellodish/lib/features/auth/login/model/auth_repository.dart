import '../../../../network/api_service.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<LoginResponse> login({
    required String phoneNo,
    required String countryCode,
  }) async {
    final response = await _apiService.post('/auth/login', {
      'phone': phoneNo,
      'country_code': countryCode,
    });
    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> resendOtp({
    required String phoneNo,
    required String countryCode,
  }) async {
    final response = await _apiService.post('/auth/resend-otp', {
      'phone': phoneNo,
      'country_code': countryCode,
    });
    return LoginResponse.fromJson(response);
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String otpId,
    required String otp,
  }) async {
    final response = await _apiService.post('/auth/verify-otp', {
      'otpId': otpId,
      'otp': otp,
    });
    return VerifyOtpResponse.fromJson(response);
  }

  Future<bool> logout() async {
    final response = await _apiService.post('/auth/logout', {});
    return response['status'] == 'success';
  }
}