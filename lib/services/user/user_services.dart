// lib/services/user/user_service.dart
import 'package:attedance_management_system/models/punch.dart';
import 'package:attedance_management_system/services/api_service.dart';
import 'package:attedance_management_system/core/constants/api_endpoints.dart';

/// A small service to call punch APIs.
/// Uses your existing ApiService (http wrapper).
class UserService {
  final ApiService _api = ApiService();

  Future<Map<String, dynamic>?> punch(Punch punchData) async {
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
}
