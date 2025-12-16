import 'package:attedance_management_system/modules/common/controller/loading_controller.dart';
import 'package:attedance_management_system/modules/user/model/user_calendar.dart';
import 'package:attedance_management_system/modules/user/services/user_activity_service.dart';
import 'package:get/get.dart';
import '../../../data/utils/app_helper.dart';
import '../../models/attendance_activity.dart';
import '../services/user_home_service.dart';

class UserHomeController extends GetxController {
  final UserHomeService _service = UserHomeService();
  final LoadingController _loadingController = Get.find<LoadingController>();
  final UserActivityService _userActivityService = UserActivityService();

  // reactive state
  final RxBool isLoading = false.obs;
  final RxString currentStatus = ''.obs; // "checked_in" / "checked_out" / ''

  final RxList<AttendanceActivity> recentPunches = <AttendanceActivity>[].obs;

  final Rx<UserCalendarResponse?> userCalendar = Rx<UserCalendarResponse?>(null);

  List<AttendanceActivity> get filteredAttendanceActivitiesList => recentPunches;

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> refreshHome() async {
    // await loadRecentPunches();
    await getUserCalendar("2025");
  }


  Future<void> getUserCalendar(String year) async {
    final userKey = AppHelper.getProfileUser().key!;
    _loadingController.start();

    try {
      final res = await _service.getUserCalendar(userKey, year);

      print('res is the $res');

      userCalendar.value = UserCalendarResponse.fromJson(res);
    } catch (e) {
      print('getUserCalendar error: $e');
    } finally {
      _loadingController.hide();
    }
  }



}


