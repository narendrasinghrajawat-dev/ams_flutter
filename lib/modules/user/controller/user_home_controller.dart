import 'package:get/get.dart';

import '../../models/attendance_activity.dart';
import '../services/user_home_service.dart';

class UserHomeController extends GetxController {
  final UserHomeService _service = UserHomeService();

  // reactive state
  final RxBool isLoading = false.obs;
  final RxString currentStatus = ''.obs; // "checked_in" / "checked_out" / ''

  final RxList<AttendanceActivity> recentPunches = <AttendanceActivity>[].obs;

  @override
  void onReady() {
    super.onReady();
    // optional: load last few punches for home
    // loadRecentPunches();
  }


  Future<void> refreshHome() async {
    // await loadRecentPunches();
  }


  Future<void> loadRecentPunches({int limit = 10}) async {
    try {
      final list = await _service.fetchPunches(limit: limit);
      recentPunches
        ..clear()
        ..addAll(list.map((e) => AttendanceActivity.fromJson(e)));
    } catch (e) {
      // log / snackbar if needed
      print('UserHomeController.loadRecentPunches error: $e');
    }
  }

  /// Punch in / out from Home screen
  Future<bool> punch(AttendanceActivity punchInData) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final res = await _service.punch(punchInData);
      if (res != null) {
        final punch = AttendanceActivity.fromJson(res);
        recentPunches.insert(0, punch);
        currentStatus.value = 'checked_in'; // or decide from punch type
        Get.snackbar(
          'Success',
          'Checked in at ${punch.punchTime}',
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar('Error', 'Failed to check in');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }


}
