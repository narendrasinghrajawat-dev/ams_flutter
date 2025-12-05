// lib/services/user/user_service.dart
import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../models/apply_leave_request.dart';
import '../../models/attendance_activity.dart';
import '../common/api_service.dart';

/// A small service to call punch APIs.
/// Uses your existing ApiService (http wrapper).
class UserService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>?> punch(AttendanceActivity punchData) async {
    try {
      final resp = await _api.post(ApiEndpoints.punch, punchData.toJson());
      return resp;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch recent punches for the user
  Future<List<Map<String, dynamic>>> fetchPunches({int limit = 20}) async {
    try {
      // Example endpoint that returns user's punches
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



  Future<List<Map<String, dynamic>>> fetchAllAttedanceActivity(String userKey) async {
    print('fetchAllAttedanceActivity serice isidfds fdfd ');

    try {
      final resp = await _api.get("${ApiEndpoints.getAllAttedanceActivity}$userKey");
      print('resp is the $resp');

      if (resp is List) {
        return List<Map<String, dynamic>>.from(resp);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>> fetchLeavesStatus(String userKey) async {
    print('fetchAllAttedanceActivity serice isidfds fdfd ');

    try {
      final resp = await _api.get("${ApiEndpoints.getAllLeavesStatus}$userKey");
      print('resp is the $resp');

      if (resp is List) {
        return List<Map<String, dynamic>>.from(resp);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }


  Future<Map<String, dynamic>?> applyLeave(ApplyLeaveRequest request) async {
    print('apply services called');
    try {
      final res = await _api.post(ApiEndpoints.applyLeaves, request.toJson());
      print('res is teh $res');
      // If backend returns { message, statusCode, data },
      // you can inspect `res` here if needed.
      // For now, if no exception => success.
      return res;
    } catch (e) {
      print('applyLeave error: $e');
      return null;
    }
  }

}
