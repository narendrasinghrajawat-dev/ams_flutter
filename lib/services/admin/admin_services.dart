import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import '../api_service.dart';


class AdminServices {
  final ApiService apiService;

  AdminServices({ApiService? api}) : apiService = api ?? ApiService();

  Future<List<Map<String, dynamic>>> fetchUsersList() async {
    try {
      final apiResponse = await apiService.get(ApiEndpoints.usersList);
      if (apiResponse is List) {
        final List<Map<String, dynamic>> validatedList = [];
        for (final item in apiResponse) {
          if (item is Map<String, dynamic>) {
            validatedList.add(item);
          } else {
            print('Warning: Skipping item with unexpected type: ${item.runtimeType}');
          }
        }
        return validatedList;
      }

      print('Error: API response was not a list, but was: ${apiResponse.runtimeType}');
      return [];

    } catch (e) {
      // Handle any network or service exceptions
      print('Failed to fetch user list: $e');
      return [];
    }
  }

}
