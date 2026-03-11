import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'HomeModel.dart';
import 'HomeRepository.dart';


enum HomeState { idle, loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  HomeState _state = HomeState.idle;
  HomeModel? _homeData;
  String _errorMessage = '';

  HomeState get state => _state;
  HomeModel? get homeData => _homeData;
  String get errorMessage => _errorMessage;

  List<BannerModel> get banners => _homeData?.banners ?? [];
  List<CategoryModel> get categories => _homeData?.categories ?? [];
  List<RestaurantModel> get popularRestaurants =>
      _homeData?.popularRestaurants ?? [];
  List<RestaurantModel> get allRestaurants => _homeData?.allRestaurants ?? [];

  Future<void> fetchHomeData() async {
    _state = HomeState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _homeData = await _repository.getHomeData();
      _state = HomeState.success;
      developer.log('HomeViewModel: Fetched home data', name: 'HomeViewModel');
    } catch (e) {
      _errorMessage = 'Failed to load home data.';
      _state = HomeState.error;
      developer.log('HomeViewModel: Error — $e',
          name: 'HomeViewModel', error: e);
    }
    notifyListeners();
  }
}