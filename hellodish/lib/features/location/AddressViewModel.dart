import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'AddressModel.dart';
import 'AddressRepository.dart';


enum AddressState { idle, loading, success, error }

class AddressViewModel extends ChangeNotifier {
  final AddressRepository _repository = AddressRepository();

  AddressState _state = AddressState.idle;
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;
  String _errorMessage = '';

  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  AddressState get state => _state;
  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress;
  String get errorMessage => _errorMessage;
  List<dynamic> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  bool get hasAddress => _addresses.isNotEmpty;

  String get displayAddress {
    if (_selectedAddress != null) return _selectedAddress!.shortAddress;
    if (_addresses.isNotEmpty) return _addresses.first.shortAddress;
    return 'Select your location';
  }

  String get displayEmoji {
    if (_selectedAddress != null) return _selectedAddress!.typeEmoji;
    if (_addresses.isNotEmpty) return _addresses.first.typeEmoji;
    return '📍';
  }

  String get displayType {
    if (_selectedAddress != null) {
      return _selectedAddress!.addressType.capitalize();
    }
    if (_addresses.isNotEmpty) {
      return _addresses.first.addressType.capitalize();
    }
    return 'Location';
  }

  Future<void> fetchAddresses() async {
    _state = AddressState.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      _addresses = await _repository.getAddresses();
      if (_addresses.isNotEmpty && _selectedAddress == null) {
        _selectedAddress = _addresses.first;
      }
      _state = AddressState.success;
      developer.log(
        'AddressViewModel: Fetched ${_addresses.length} addresses',
        name: 'AddressViewModel',
      );
    } catch (e) {
      _errorMessage = 'Failed to load addresses.';
      _state = AddressState.error;
      developer.log('AddressViewModel: Error — $e',
          name: 'AddressViewModel', error: e);
    }
    notifyListeners();
  }

  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  Future<void> searchPlaces(String query) async {
    if (query.trim().isEmpty) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/search'
            '?q=${Uri.encodeComponent(query)}'
            '&format=json'
            '&addressdetails=1'
            '&limit=8',
      );
      final response = await http.get(
        uri,
        headers: {
          'Accept-Language': 'en',
          'User-Agent': 'HellodishApp/1.0',
        },
      ).timeout(const Duration(seconds: 10));

      _searchResults = jsonDecode(response.body) as List<dynamic>;
      developer.log(
        'AddressViewModel: Found ${_searchResults.length} places for "$query"',
        name: 'AddressViewModel',
      );
    } catch (e) {
      _searchResults = [];
      developer.log('AddressViewModel: Search error — $e',
          name: 'AddressViewModel', error: e);
    }

    _isSearching = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }
}

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}