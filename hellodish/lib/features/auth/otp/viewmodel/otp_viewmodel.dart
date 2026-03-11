import 'package:flutter/material.dart';
import '../../../../core/cache/PrefManager.dart';
import '../../login/model/auth_repository.dart';

import '../../../../network/api_service.dart';

enum OtpState { idle, loading, success, error }

class OtpViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();
  final PrefManager _prefManager = PrefManager();
  final ApiService _apiService = ApiService();

  OtpState _state = OtpState.idle;
  String _errorMessage = '';
  String _token = '';

  OtpState get state => _state;
  String get errorMessage => _errorMessage;
  String get token => _token;

  Future<bool> verifyOtp({
    required String otpId,
    required String otp,
  }) async {
    _state = OtpState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _repository.verifyOtp(
        otpId: otpId,
        otp: otp,
      );

      if (response.isSuccess && response.token != null) {
        _token = response.token!;

        // Save token for future sessions
        await _prefManager.saveAuthToken(_token);

        // Set token on ApiService for all future requests
        _apiService.setAuthToken(_token);

        // Save user info if present in response
        if (response.user != null) {
          final user = response.user!;
          await _prefManager.saveUserInfo(
            userId: user.id,
            firstName: user.fName,
            lastName: user.lName,
            phone: user.phone,
            countryCode: user.countryCode,
          );
        }

        _state = OtpState.success;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = OtpState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'OTP verification failed. Please try again.';
      _state = OtpState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOtp({
    required String phoneNo,
    required String countryCode,
  }) async {
    _state = OtpState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _repository.resendOtp(
        phoneNo: phoneNo,
        countryCode: countryCode,
      );

      if (response.isSuccess) {
        _state = OtpState.idle;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = OtpState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to resend OTP.';
      _state = OtpState.error;
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = OtpState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}