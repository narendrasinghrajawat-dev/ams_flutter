import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';

class UserProfileService {
  final ApiService _api = ApiService();

  /// Calls backend to change password.
  /// Returns the decoded JSON response (Map) or throws on network error.
  Future<Map<String, dynamic>?> changePassword(String userKey, String newPassword) async {
    final body = {
      'userKey': userKey,
      'newPassword': newPassword,
    };

    // adapt path if your backend path is different
    final resp = await _api.post(ApiEndpoints.changePassword, body);

    print('res p is teh $resp');

    // If ApiService already decodes JSON, return it; else decode as needed
    return resp;
  }
}
