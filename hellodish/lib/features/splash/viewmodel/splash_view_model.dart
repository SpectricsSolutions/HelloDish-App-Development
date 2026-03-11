import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../network/api_service.dart';
import 'dart:developer' as developer;

import '../../../core/cache/PrefManager.dart';

enum SplashState { idle, loading, done }

class SplashViewModel extends ChangeNotifier {
  final PrefManager _prefManager = PrefManager();
  final ApiService _apiService = ApiService();

  SplashState _state = SplashState.idle;
  bool _isLoggedIn = false;

  SplashState get state => _state;
  bool get isLoggedIn => _isLoggedIn;

  /// Returns true if user has a saved token (logged in),
  /// false if guest API was called (not logged in).
  Future<bool> initialize() async {
    _state = SplashState.loading;
    notifyListeners();

    try {
      //todo set hardcoded token
    //  await _prefManager.saveAuthToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQiLCJ1c2VySWQiOiI1MjU1IiwiaWF0IjoxNzczMjI3MDE3LCJleHAiOjE4MDQ3NjMwMTd9.ULuem_AXF45bSNK8hqncDhrsjcTnBgLaliQzzMxkHQs");
      final hasToken = await _prefManager.hasAuthToken();

      if (hasToken) {
        // Restore token into ApiService for authenticated requests
        final token = await _prefManager.getAuthToken();
        _apiService.setAuthToken(token!);
        _isLoggedIn = true;
        developer.log('SplashViewModel: Token found — going to Home',
            name: 'SplashViewModel');
      } else {
        // No token — call guest API
        await _callGuestApi();
        _isLoggedIn = false;
        developer.log('SplashViewModel: No token — going to Login',
            name: 'SplashViewModel');
      }
    } catch (e) {
      developer.log('SplashViewModel: Error during init — $e',
          name: 'SplashViewModel', error: e);
      _isLoggedIn = false;
    }

    _state = SplashState.done;
    notifyListeners();
    return _isLoggedIn;
  }

  Future<void> _callGuestApi() async {
    try {
      final deviceId = await _getDeviceId();
      await _apiService.post('/auth/guest', {
        'ipAddress': deviceId,
        'fcmToken': '',
      });
    } catch (e) {
      developer.log('SplashViewModel: Guest API failed — $e',
          name: 'SplashViewModel', error: e);
    }
  }

  Future<String> _getDeviceId() async {
    try {
      if (Platform.isAndroid) {
        // Use a stable Android identifier
        return 'android_${Platform.operatingSystemVersion.replaceAll(' ', '_')}';
      } else if (Platform.isIOS) {
        return 'ios_${Platform.operatingSystemVersion.replaceAll(' ', '_')}';
      }
    } catch (_) {}
    return 'unknown_device';
  }
}