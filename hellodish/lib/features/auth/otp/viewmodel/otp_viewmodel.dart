import 'package:flutter/material.dart';
import 'dart:io';
import '../../login/model/auth_repository.dart';

enum OtpState { idle, loading, success, error }

class OtpViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

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
      final deviceType = Platform.isAndroid ? 'android' : 'ios';
      const firebaseToken = ''; // Replace with actual FCM token

      final response = await _repository.verifyOtp(
        otpId: otpId,
        otp: otp,
        firebaseToken: firebaseToken,
        deviceType: deviceType,
      );

      if (response.isSuccess && response.token != null) {
        _token = response.token!;
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
      final cleanCode = countryCode.replaceAll('+', '');
      final response = await _repository.resendOtp(
        phoneNo: phoneNo,
        countryCode: cleanCode,
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