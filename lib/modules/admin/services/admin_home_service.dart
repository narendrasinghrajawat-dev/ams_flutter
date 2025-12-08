import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import '../../common/services/api_service.dart';

class AdminHomeService {
  final ApiService apiService;

  AdminHomeService({ApiService? api})
      : apiService = api ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchUsersList() async {
    print('service scalled');


    try {
      // 1. Await the raw API response
      final rawApiResponse = await apiService.get(ApiEndpoints.usersList);

      print('rawApiResponse is teh $rawApiResponse');

      // Check if the response is indeed a List<dynamic>
      if (rawApiResponse is List) {
        // 2. Map the List<dynamic> to List<Map<String, dynamic>>
        // Forcing the cast of each item ensures type safety for the function's return type.
        final List<Map<String, dynamic>> userList = rawApiResponse
            .map((item) => item as Map<String, dynamic>)
            .toList();

        return userList;
      }
      // Handle cases where the API returns something other than a list
      return [];

    } catch (e) {
      print('Failed to fetch user list: $e');
      // Important: In a real app, log or handle the error more gracefully
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchAttendanceList() async {
    try {
      final apiResponse =
      await apiService.get(ApiEndpoints.getTotalAttendance);
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
      print('Failed to fetch attendance list: $e');
      return [];
    }
  }

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
}
