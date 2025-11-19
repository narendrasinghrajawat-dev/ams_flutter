import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import '../api_service.dart';


class AuthServices {
  final ApiService apiService;

  AuthServices({ApiService? api}) : apiService = api ?? ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await apiService.post(ApiEndpoints.login, {'email': email, 'password': password});
    return resp;
  }


}
