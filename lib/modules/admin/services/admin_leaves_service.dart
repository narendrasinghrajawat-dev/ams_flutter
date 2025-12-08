import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';
import '../../models/admin_action.dart';
import '../../models/apply_leave_request.dart';

class AdminLeavesService {
  final ApiService apiService;

  AdminLeavesService({ApiService? api})
      : apiService = api ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchLeavesList() async {
    try {
      final apiResponse = await apiService
          .get(ApiEndpoints.getAllLeavesRequests);
      if (apiResponse is List) {
        final List<Map<String, dynamic>> validatedList = [];
        for (final item in apiResponse) {
          if (item is Map<String, dynamic>) {
            validatedList.add(item);
          } else {
            print(
                'Warning: Skipping item with unexpected type: ${item.runtimeType}');
          }
        }
        return validatedList;
      }

      print(
          'Error: API response was not a list, but was: ${apiResponse.runtimeType}');
      return [];
    } catch (e) {
      print('Failed to fetch leave list: $e');
      return [];
    }
  }

  Future<ApplyLeaveRequest?> adminActionOnLeave(AdminAction payload) async {
    try {
      final endpoint =
          ApiEndpoints.adminActionOnLeaveRequest;
      final apiResponse =
      await apiService.post(endpoint, payload.toJson());
      final applyLeaveRequest =
      ApplyLeaveRequest.fromJson(apiResponse);
      return applyLeaveRequest;
    } catch (e) {
      print('adminActionOnLeave failed: $e');
      return null;
    }
  }
}
