import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import '../../common/services/api_service.dart';
import '../../models/login.dart';


class AuthServices {
  final ApiService apiService;

  AuthServices({ApiService? api}) : apiService = api ?? ApiService();

// Change the signature to accept the Map payload
  Future<Map<String, dynamic>> login(Login loginPayload) async {
    // Use the payload directly in the post request body
    final resp = await apiService.postWithoutHeaders(ApiEndpoints.login, loginPayload.toJson());
    return resp;
  }


}
