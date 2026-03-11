import 'package:flutter/material.dart';

import '../../../../network/api_service.dart';
import 'dart:developer' as developer;

import '../../../core/cache/PrefManager.dart';

enum MenuState { idle, loading, done }

class MenuViewModel extends ChangeNotifier {
  final PrefManager _prefManager = PrefManager();
  final ApiService _apiService = ApiService();

  MenuState _state = MenuState.idle;
  String _userName = '';
  String _userPhone = '';
  String _userCountryCode = '+91';
  String _errorMessage = '';

  MenuState get state => _state;
  String get userName => _userName;
  String get userPhone => _userPhone;
  String get userCountryCode => _userCountryCode;
  String get errorMessage => _errorMessage;

  /// Load saved user info from prefs
  Future<void> loadUserInfo() async {
    _userName = await _prefManager.getUserName() ?? '';
    _userPhone = await _prefManager.getUserPhone() ?? '';
    _userCountryCode = await _prefManager.getUserCountryCode() ?? '+91';
    notifyListeners();
  }

  /// Call logout API, clear prefs, return true on success
  Future<bool> logout() async {
    _state = MenuState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/logout', {});
      final success = response['status'] == 'success';

      if (success) {
        await _prefManager.clearAll();
        _apiService.clearAuthToken();
        developer.log('MenuViewModel: Logout successful', name: 'MenuViewModel');
      } else {
        _errorMessage = response['message'] ?? 'Logout failed. Please try again.';
        developer.log('MenuViewModel: Logout failed — $_errorMessage', name: 'MenuViewModel');
      }

      _state = MenuState.done;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = MenuState.done;
      developer.log('MenuViewModel: Logout error — $e', name: 'MenuViewModel', error: e);
      notifyListeners();
      return false;
    }
  }
}