import '../../../../network/api_service.dart';
import 'AddressModel.dart';


class AddressRepository {
  final ApiService _apiService = ApiService();

  Future<List<AddressModel>> getAddresses() async {
    final response = await _apiService.get('/user/address');
    if (response['status'] == 'success') {
      final data = response['data'] as List<dynamic>? ?? [];
      return data
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}