
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

  // Service Class Method

// The service function should return the list of leaves, but must first process the map response.
  Future<List<Map<String, dynamic>>> fetchLeavesBalance(String userKey) async {
    try {
      // 1. Await the API call. We expect a single Map/Object (the DB document).
      final resp = await _api.get("${ApiEndpoints.getLeaveBalance}$userKey");

      // 2. Check if the response is a Map and contains the 'leavesBalance' key.
      if (resp is Map<String, dynamic> && resp.containsKey('leavesBalance')) {

        // 3. Extract the list from the 'leavesBalance' key.
        final leavesList = resp['leavesBalance'];

        // 4. Ensure the extracted data is indeed a list before returning.
        if (leavesList is List) {
          return List<Map<String, dynamic>>.from(leavesList);
        }
      }

      // Return an empty list if the expected data structure is not found.
      return [];

    } catch (e) {
      // Re-throw the error for the controller to catch and handle.
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
