import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../data/services/api_service.dart';

class AuthRepo {
  final ApiService apiService;

  AuthRepo({ApiService? api}) : apiService = api ?? ApiService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    final resp = await apiService.post(ApiEndpoints.login, {'email': email, 'password': password});
    return resp;
  }
}
