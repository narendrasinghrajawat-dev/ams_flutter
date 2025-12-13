import 'package:attedance_management_system/modules/user/services/user_activity_service.dart';
import 'package:get/get.dart';
import '../../models/attendance_activity.dart';
import '../services/user_home_service.dart';

class UserHomeController extends GetxController {
  final UserHomeService _service = UserHomeService();
  final UserActivityService _userActivityService = UserActivityService();

  // reactive state
  final RxBool isLoading = false.obs;
  final RxString currentStatus = ''.obs; // "checked_in" / "checked_out" / ''

  final RxList<AttendanceActivity> recentPunches = <AttendanceActivity>[].obs;
  List<AttendanceActivity> get filteredAttendanceActivitiesList => recentPunches;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> refreshHome() async {
    // await loadRecentPunches();
  }


}


