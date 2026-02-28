
import '../../../../network/api_service.dart';
import '../model/auth_model.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  Future<LoginResponse> login({
    required String phoneNo,
    required String countryCode,
    required String deviceType,
  }) async {
    final response = await _apiService.post('/auth/login', {
      'phone_no': phoneNo,
      'country_code': countryCode,
      'device_type': deviceType,
    });
    return LoginResponse.fromJson(response);
  }

  Future<LoginResponse> resendOtp({
    required String phoneNo,
    required String countryCode,
  }) async {
    final response = await _apiService.post('/auth/resend-otp', {
      'phone_no': phoneNo,
      'country_code': countryCode,
    });
    return LoginResponse.fromJson(response);
  }

  Future<VerifyOtpResponse> verifyOtp({
    required String otpId,
    required String otp,
    required String firebaseToken,
    required String deviceType,
  }) async {
    final response = await _apiService.post('/auth/verify-otp', {
      'otpId': otpId,
      'otp': otp,
      'firebase_token': firebaseToken,
      'device_type': deviceType,
    });
    return VerifyOtpResponse.fromJson(response);
  }

  Future<bool> logout() async {
    final response = await _apiService.post('/auth/logout', {});
    return response['status'] == 'success';
  }
}
