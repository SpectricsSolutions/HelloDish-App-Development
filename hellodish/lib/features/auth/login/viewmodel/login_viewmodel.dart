import 'package:flutter/material.dart';
import 'dart:io';
import '../model/auth_model.dart';
import '../model/auth_repository.dart';

enum LoginState { idle, loading, success, error }

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  LoginState _state = LoginState.idle;
  String _errorMessage = '';
  String _otpId = '';
  String _phoneNo = '';
  String _countryCode = '+91';

  LoginState get state => _state;
  String get errorMessage => _errorMessage;
  String get otpId => _otpId;
  String get phoneNo => _phoneNo;
  String get countryCode => _countryCode;

  void setCountryCode(String code) {
    _countryCode = code;
    notifyListeners();
  }

  void setPhoneNo(String phone) {
    _phoneNo = phone;
  }

  Future<bool> login(String phoneNo) async {
    _phoneNo = phoneNo;
    _state = LoginState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final deviceType = Platform.isAndroid ? 'android' : 'ios';
      final cleanCountryCode = _countryCode.replaceAll('+', '');

      final response = await _repository.login(
        phoneNo: phoneNo,
        countryCode: cleanCountryCode,
        deviceType: deviceType,
      );

      if (response.isSuccess && response.otpId != null) {
        _otpId = response.otpId!;
        _state = LoginState.success;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = LoginState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = LoginState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendOtp() async {
    _state = LoginState.loading;
    notifyListeners();

    try {
      final cleanCountryCode = _countryCode.replaceAll('+', '');
      final response = await _repository.resendOtp(
        phoneNo: _phoneNo,
        countryCode: cleanCountryCode,
      );

      if (response.isSuccess && response.otpId != null) {
        _otpId = response.otpId!;
        _state = LoginState.success;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response.message;
        _state = LoginState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Failed to resend OTP.';
      _state = LoginState.error;
      notifyListeners();
      return false;
    }
  }

  void resetState() {
    _state = LoginState.idle;
    _errorMessage = '';
    notifyListeners();
  }
}
