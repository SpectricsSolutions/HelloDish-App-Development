import '../../../../network/api_service.dart';
import 'HomeModel.dart';


class HomeRepository {
  final ApiService _apiService = ApiService();

  Future<HomeModel?> getHomeData() async {
    final response = await _apiService.get('/home');
    if (response['status'] == 'success') {
      return HomeModel.fromJson(response);
    }
    return null;
  }
}