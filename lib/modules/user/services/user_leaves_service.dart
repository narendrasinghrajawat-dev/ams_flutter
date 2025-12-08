
import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';
import '../../models/apply_leave_request.dart';

class UserLeavesService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> fetchLeavesStatus(String userKey) async {
    try {
      final resp =
      await _api.get("${ApiEndpoints.getAllLeavesStatus}$userKey");
      if (resp is List) {
        return List<Map<String, dynamic>>.from(resp);
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> applyLeave(ApplyLeaveRequest request) async {
    try {
      final res =
      await _api.post(ApiEndpoints.applyLeaves, request.toJson());
      return res;
    } catch (e) {
      print('UserLeavesService.applyLeave error: $e');
      return null;
    }
  }

  Future<void> cancelLeave(String leaveId) async {
    await _api.delete('${ApiEndpoints.cancelLeaves}$leaveId');
  }
}
