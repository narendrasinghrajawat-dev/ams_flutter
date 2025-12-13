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

  final RxList<dynamic> activities = <dynamic>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onReady() {
    // super.onReady();
    fetchActivities();
  }

  /// 🔄 Called when Activity tab opens
  void resetToToday() {
    selectedDate.value = DateTime.now();
    fetchActivities();
  }

  /// 📅 Change date from picker
  void changeDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
    fetchActivities();
  }

  Future<void> refreshActivity() async {
    await fetchActivities();
  }

  Future<void> fetchActivities() async {
    try {
      _loadingController.start();

      final dateStr =
      DateFormat('yyyy-MM-dd').format(selectedDate.value);

      final data = await _service.fetchActivitiesByDate(dateStr);

      activities
        ..clear()
        ..addAll(data);
    } catch (e) {
      activities.clear();
    } finally {
      _loadingController.hide();
    }
  }
}
