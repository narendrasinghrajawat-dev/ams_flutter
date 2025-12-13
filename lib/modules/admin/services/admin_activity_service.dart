
import '../../../core/constants/api_endpoints.dart';
import '../../common/services/api_service.dart';

class AdminActivityService {
  final ApiService _api = ApiService();

  Future<List<dynamic>> fetchActivitiesByDate(String date) async {
    final res = await _api.get(
      '${ApiEndpoints.fetchActivitiesByDate}$date',
    );

    return res;
  }
}
