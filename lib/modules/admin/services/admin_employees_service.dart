import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import '../../common/services/api_service.dart';

class AdminEmployeesService {
  final ApiService apiService;

  AdminEmployeesService({ApiService? api})
      : apiService = api ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchUsersList() async {
    try {
      final apiResponse =
      await apiService.get(ApiEndpoints.usersList);

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
      print('Failed to fetch user list: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> createUser(
      Map<String, dynamic> payload) async {
    try {
      final apiResponse =
      await apiService.post(ApiEndpoints.createUser, payload);
      return apiResponse;
    } catch (e) {
      print('Create user failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateUser(
      String id, Map<String, dynamic> payload) async {
    try {
      final endpoint = "${ApiEndpoints.updateUser}$id";
      final apiResponse =
      await apiService.update(endpoint, payload);
      return apiResponse;
    } catch (e) {
      print('Update user failed: $e');
      return null;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final endpoint = "${ApiEndpoints.deleteUser}$id";
      await apiService.delete(endpoint);
      return true;
    } catch (e) {
      print('Delete user failed: $e');
      return false;
    }
  }
}
