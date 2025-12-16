import 'package:attedance_management_system/modules/models/attendance_activity.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';

import '../../common/controller/loading_controller.dart';
import '../services/admin_activity_service.dart';

class AdminActivityController extends GetxController {
  final AdminActivityService _service = AdminActivityService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxList<AttendanceActivity> activities = <AttendanceActivity>[].obs;
  final Rx<String> selectedDate = DateTime.now().toIso8601String().obs;

  @override
  void onReady() {
    // super.onReady();
    fetchActivities();
  }

  /// 🔄 Called when Activity tab opens
  void resetToToday() {
    selectedDate.value = DateTime.now().toIso8601String();
    fetchActivities();
  }


  /// 📅 Change date from picker (STRING ONLY)
  void changeDate(String date) {
    selectedDate.value = date;
    fetchActivities();
  }

  Future<void> refreshActivity() async {
    await fetchActivities();
  }

  Future<void> fetchActivities() async {

    activities.clear();
    try {
      _loadingController.start();

      final dateStr = selectedDate.value;

      final data = await _service.fetchActivitiesByDate(dateStr);

      activities
        ..clear()
        ..addAll(data.map((e) => AttendanceActivity.fromJson(e)).toList());
    } catch (e) {
      activities.clear();
    } finally {
      _loadingController.hide();
    }
  }
}
