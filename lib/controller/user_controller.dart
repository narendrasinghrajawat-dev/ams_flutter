// lib/modules/user/user_controller.dart
import 'package:attedance_management_system/models/attendance_activity.dart';
import 'package:get/get.dart';
import '../data/utils/app_helper.dart';
import '../models/apply_leave_request.dart';
import '../services/common/storage_service.dart';
import '../services/user/user_services.dart';

/// Controller to handle user punch in / punch out flows.
/// Use Get.find<UserController>() to access this controller in UI.
class UserController extends GetxController {
  final UserService _service = UserService();
  final StorageService _storage = StorageService();


  RxList<AttendanceActivity> attendanceActivitiesList = <AttendanceActivity>[].obs;
  RxList<ApplyLeaveRequest> appliedLeaves = <ApplyLeaveRequest>[].obs;

  RxBool applyingLeave = false.obs;

  List<AttendanceActivity> get filteredAttendanceActivitiesList => attendanceActivitiesList;
  List<ApplyLeaveRequest> get filteredAppliedLeavesList => appliedLeaves;


  // reactive state
  final RxBool isLoading = false.obs;
  final RxString currentStatus = ''.obs; // "checked_in" / "checked_out" / ''

  @override
  void onInit() {
    super.onInit();
    // optional: load last punches from API/local storage
    // fetchLastPunches();
    loadAttendanceActivities(AppHelper.getProfileUser().key!);
    loadLeavesStatus(AppHelper.getProfileUser().key!);

  }


  /// Perform a punch-in.
  /// You can pass optional extras like location, device info, note, etc.
  Future<bool> punchIn(AttendanceActivity punchInData) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final res = await _service.punch(punchInData);
      // res expected to be created punch object (map)
      if (res != null) {
        final punch = AttendanceActivity.fromJson(res);
        filteredAttendanceActivitiesList.insert(0, punch);
        currentStatus.value = 'checked_in';
        Get.snackbar('Success', 'Checked in at ${punch.punchTime}', snackPosition: SnackPosition.BOTTOM);
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

  /// Perform a punch-out.
  Future<bool> punchOut(AttendanceActivity punchOutData) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final res = await _service.punch(punchOutData);
      if (res != null ) {
        final punch = AttendanceActivity.fromJson(res);
        filteredAttendanceActivitiesList.insert(0, punch);
        currentStatus.value = 'checked_out';
        Get.snackbar('Success', 'Checked out at ${punch.punchTime}', snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        Get.snackbar('Error', 'Failed to check out');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Helper: clear history (for debug)
  void clearHistory() {
    filteredAttendanceActivitiesList.clear();
    currentStatus.value = '';
  }

  loadAttendanceActivities(String userKey) async {
    print('loadAttendanceActivities called is the ');

    try {
      final List<Map<String, dynamic>> res = await _service.fetchAllAttedanceActivity(userKey);
      if (!AppHelper.isEmptyOrNull(res)) {
        attendanceActivitiesList.clear();
        for (var item in res) {
          final user = AttendanceActivity.fromJson(item);
          attendanceActivitiesList.add(user);
        }
      }
    } catch (e) {
      print('Error loading users: $e');
    } finally {
    }
  }



  loadLeavesStatus(String userKey) async {
    print('loadAttendanceActivities called is the ');

    try {
      final List<Map<String, dynamic>> res = await _service.fetchLeavesStatus(userKey);
      if (!AppHelper.isEmptyOrNull(res)) {
        appliedLeaves.clear();
        for (var item in res) {
          final user = ApplyLeaveRequest.fromJson(item);
          appliedLeaves.add(user);
        }

        appliedLeaves.refresh();
      }
    } catch (e) {
      print('Error loading users: $e');
    } finally {
    }
  }


  Future<bool> applyLeave(ApplyLeaveRequest request) async {
    applyingLeave.value = true;

    print('apply leavests rt s');
    try {
      final ok = await _service.applyLeave(request);
      print('ok is the $ok');

      if(ok != null){
        print('ok start formr');
        print('before add length is hte ${appliedLeaves.length}');

        appliedLeaves.add(ApplyLeaveRequest.fromJson(ok));
        print('after add length is hte ${appliedLeaves.length}');

      }
      appliedLeaves.refresh();

      print('yes return success');
      return ok != null ? true : false;
    } catch (e) {
      print('UserController.applyLeave error: $e');
      return false;
    } finally {
      applyingLeave.value = false;
    }
  }



}
