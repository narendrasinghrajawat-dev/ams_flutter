import 'package:attedance_management_system/core/constants/api_endpoints.dart';

import '../../common/services/api_service.dart';
import '../../models/attendance_activity.dart';

class UserHomeService {
  final ApiService _api = ApiService();


  Future<Map<String, dynamic>> getUserCalendar(String userKey, String year) async {
    try {
      final path = '${ApiEndpoints.getUserCalendar}$userKey/$year';
      final resp = await _api.get(path);
      return resp;
    } catch (e) {
      rethrow;
    }
  }
}
