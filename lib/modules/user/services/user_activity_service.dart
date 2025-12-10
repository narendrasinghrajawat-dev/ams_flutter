import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';
import '../../models/attendance_activity.dart';


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

  Future<Map<String, dynamic>?> punch(AttendanceActivity punchData) async {
    try {
      final resp = await _api.post(ApiEndpoints.punch, punchData.toJson());
      return resp;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> fetchPunches({int limit = 20}) async {
    try {
      final path = '${ApiEndpoints.punch}/recent?limit=$limit';
      final resp = await _api.get(path);
      if (resp is List) {
        return List<Map<String, dynamic>>.from(resp);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }


}
