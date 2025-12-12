// import 'package:attedance_management_system/core/constants/api_endpoints.dart';
// import '../../common/services/api_service.dart';
// import '../../models/admin_action.dart';
// import '../../models/apply_leave_request.dart';
//
// class AdminServices {
//   final ApiService apiService;
//
//   AdminServices({ApiService? api}) : apiService = api ?? ApiService();
//
//   Future<List<Map<String, dynamic>>> fetchUsersList() async {
//
//     try {
//       final apiResponse = await apiService.get(ApiEndpoints.usersList);
//
//       if (apiResponse is List) {
//         final List<Map<String, dynamic>> validatedList = [];
//         for (final item in apiResponse) {
//           if (item is Map<String, dynamic>) {
//             validatedList.add(item);
//           } else {
//             print('Warning: Skipping item with unexpected type: ${item.runtimeType}');
//           }
//         }
//         return validatedList;
//       }
//
//       print('Error: API response was not a list, but was: ${apiResponse.runtimeType}');
//       return [];
//     } catch (e) {
//       print('Failed to fetch user list: $e');
//       return [];
//     }
//   }
//
//
//   Future<List<Map<String, dynamic>>> fetchAttendanceList() async {
//     try {
//       final apiResponse = await apiService.get(ApiEndpoints.getTotalAttendance);
//       if (apiResponse is List) {
//         final List<Map<String, dynamic>> validatedList = [];
//         for (final item in apiResponse) {
//           if (item is Map<String, dynamic>) {
//             validatedList.add(item);
//           } else {
//             print('Warning: Skipping item with unexpected type: ${item.runtimeType}');
//           }
//         }
//         return validatedList;
//       }
//
//       print('Error: API response was not a list, but was: ${apiResponse.runtimeType}');
//       return [];
//     } catch (e) {
//       print('Failed to fetch user list: $e');
//       return [];
//     }
//   }
//
//   Future<List<Map<String, dynamic>>> fetchLeavesList() async {
//     try {
//       final apiResponse = await apiService.get(ApiEndpoints.getAllLeavesRequests);
//       if (apiResponse is List) {
//         final List<Map<String, dynamic>> validatedList = [];
//         for (final item in apiResponse) {
//           if (item is Map<String, dynamic>) {
//             validatedList.add(item);
//           } else {
//             print('Warning: Skipping item with unexpected type: ${item.runtimeType}');
//           }
//         }
//         return validatedList;
//       }
//
//       print('Error: API response was not a list, but was: ${apiResponse.runtimeType}');
//       return [];
//     } catch (e) {
//       print('Failed to fetch user list: $e');
//       return [];
//     }
//   }
//
//
//   /// Create a new user.
//   /// Returns the created user JSON on success, or null on failure.
//   Future<Map<String, dynamic>?> createUser(Map<String, dynamic> payload) async {
//     print('create user called ');
//
//     try {
//       // If your endpoint is different, change ApiEndpoints.usersCreate accordingly.
//       final apiResponse = await apiService.post(ApiEndpoints.createUser, payload);
//
//       print('after service create user is the ');
//       print(apiResponse);
//
//       return apiResponse;
//     } catch (e) {
//       print('Create user failed: $e');
//       return null;
//     }
//   }
//
//   /// Update an existing user by id.
//   /// Returns the updated user JSON on success, or null on failure.
//   Future<Map<String, dynamic>?> updateUser(String id, Map<String, dynamic> payload) async {
//     print('update user ist he $id');
//
//     try {
//       // Build detail endpoint. Replace userDetail if your ApiEndpoints provides a function.
//       final endpoint = "${ApiEndpoints.updateUser}$id";
//       final apiResponse = await apiService.update(endpoint, payload);
//       return apiResponse;
//     } catch (e) {
//       print('Update user failed: $e');
//       return null;
//     }
//   }
//
//   /// Delete user by id. Returns true on success.
//   Future<bool> deleteUser(String id) async {
//     try {
//       final endpoint = "${ApiEndpoints.deleteUser}$id";
//       final apiResponse = await apiService.delete(endpoint);
//       return true;
//     } catch (e) {
//       print('Delete user failed: $e');
//       return false;
//     }
//   }
//
//
//   /// Delete user by id. Returns true on success.
//   Future<ApplyLeaveRequest?> adminActionOnLeave(AdminAction payload) async {
//     try {
//       final endpoint = "${ApiEndpoints.adminActionOnLeaveRequest}";
//       final apiResponse = await apiService.post(endpoint, payload.toJson());
//       ApplyLeaveRequest  applyLeaveRequest = ApplyLeaveRequest.fromJson(apiResponse);
//       return applyLeaveRequest;
//     } catch (e) {
//       print('Delete user failed: $e');
//       return null;
//     }
//   }
//
//
//
//
// }
