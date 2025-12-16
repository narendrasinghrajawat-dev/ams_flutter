import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:get/get.dart';

import '../../../widgets/common/ui_helper_widgets.dart';
import '../../common/controller/loading_controller.dart';
import '../../models/attendance_activity.dart';
import '../services/user_activity_service.dart';
import '../services/user_home_service.dart';

class UserActivityController extends GetxController {
  final UserActivityService _service = UserActivityService();
  // NEW: reuse same punch API as old UserHomeController

  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxList<AttendanceActivity> attendanceActivities = <AttendanceActivity>[].obs;
  final RxList<AttendanceActivity> activitiesByDate = <AttendanceActivity>[].obs;

  List<AttendanceActivity> get filteredAttendanceActivitiesList => attendanceActivities;
  List<AttendanceActivity> get filteredAttendanceActivitiesListByDate => activitiesByDate;

  @override
  void onReady() {
    super.onReady();
    final user = AppHelper.getProfileUser();
    if (user.key != null) {
      // loadAttendanceActivities(user.key!);
      getActivityByDate(DateTime.now().toIso8601String());
    }
  }

  Future<void> refreshActivity() async {
    final userKey = AppHelper.getProfileUser().key!;
    await loadAttendanceActivities(userKey);
  }

  Future<void> getActivityByDate(String date) async {
    final userKey = AppHelper.getProfileUser().key!;
    _loadingController.start();
    // activitiesByDate.clear();
    try {
      final list = await _service.fetchPunchesByDate(userKey, date);
      activitiesByDate..clear()..addAll(list.map((e) => AttendanceActivity.fromJson(e)));
      activitiesByDate.refresh();

    } catch (e) {
      // log / snackbar if needed
      print('UserHomeController.loadRecentPunches error: $e');
    } finally {
      _loadingController.hide();

    }
  }




  Future<void> loadRecentPunches({int limit = 10}) async {
    _loadingController.start();

    try {
      final list = await _service.fetchPunches(limit: limit);
      attendanceActivities
        ..clear()
        ..addAll(list.map((e) => AttendanceActivity.fromJson(e)));
      attendanceActivities.refresh();

    } catch (e) {
      // log / snackbar if needed
      print('UserHomeController.loadRecentPunches error: $e');
    } finally {
      _loadingController.hide();

    }
  }

  Future<void> loadAttendanceActivities(String userKey) async {
    print('loadAttendanceActivities called');
    _loadingController.start();
    attendanceActivities.clear();
    try {
      final List<Map<String, dynamic>> res =
      await _service.fetchAllAttendanceActivity(userKey);
      attendanceActivities.addAll(res.map((e) => AttendanceActivity.fromJson(e)));
      attendanceActivities.refresh();
    } catch (e) {
      print('UserActivityController.loadAttendanceActivities error: $e');
    } finally {
      _loadingController.hide();
    }
  }

  /// 🔹 Common punch method (Check-in / Check-out)
  /// - Calls punch API
  /// - Updates main attendance list
  /// - Shows success / error snackbar
  Future<bool> punch(AttendanceActivity punchData) async {

    _loadingController.start();

    try {
      final res = await _service.punch(punchData);
      if (res != null) {
        final punch = AttendanceActivity.fromJson(res);

        // Insert at top so today's list & _getTodayCheckIn/_getTodayCheckOut see it
        attendanceActivities.insert(0, punch);
        attendanceActivities.refresh();

        final isCheckIn = AppHelper.isCheckIn(punch.punchType);
        final actionText = isCheckIn ? 'Checked in' : 'Checked out';

        UIHelper.showSnackbar(
          'Success',
          '$actionText at ${AppHelper.formatTimeString(punch.punchTime)}',
          duration: const Duration(seconds: 7),
        );

        return true;
      } else {
        UIHelper.showSnackbar(
          'Error',
          'Failed to punch attendance',
          duration: const Duration(seconds: 7),
          type: SnackbarType.error
        );

        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      _loadingController.hide();

    }
  }
}
