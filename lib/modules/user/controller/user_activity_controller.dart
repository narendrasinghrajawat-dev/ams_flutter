import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:get/get.dart';

import '../../models/attendance_activity.dart';
import '../services/user_activity_service.dart';

class UserActivityController extends GetxController {
  final UserActivityService _service = UserActivityService();

  final RxBool isLoading = false.obs;
  final RxList<AttendanceActivity> attendanceActivities =
      <AttendanceActivity>[].obs;

  List<AttendanceActivity> get filteredAttendanceActivitiesList => attendanceActivities;

  @override
  void onReady() {
    super.onReady();
    final user = AppHelper.getProfileUser();
    if (user.key != null) {
      loadAttendanceActivities(user.key!);
    }
  }



  Future<void> refreshActivity() async {
    final userKey = AppHelper.getProfileUser().key!;
    await loadAttendanceActivities(userKey);
  }

  Future<void> loadAttendanceActivities(String userKey) async {
    print('loadAttendanceActivities called' );

    try {
      isLoading.value = true;
      final List<Map<String, dynamic>> res = await _service.fetchAllAttendanceActivity(userKey);
      print('resis the $res');
      attendanceActivities..clear()..addAll(res.map((e) => AttendanceActivity.fromJson(e)));
      attendanceActivities.refresh();
    } catch (e) {
      print('UserActivityController.loadAttendanceActivities error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
