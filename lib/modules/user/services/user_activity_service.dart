import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';


class UserActivityService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> fetchAllAttendanceActivity(String userKey) async {
    try {
      final resp = await _api.get("${ApiEndpoints.getAllAttedanceActivity}$userKey");
      if (resp is List) {
        return List<Map<String, dynamic>>.from(resp);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
