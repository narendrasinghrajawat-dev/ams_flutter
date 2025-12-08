import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../models/apply_leave_request.dart';
import '../../models/attendance_activity.dart';
import '../../models/user.dart';
import '../services/admin_home_service.dart';

class AdminHomeController extends GetxController {
  final AdminHomeService _service = AdminHomeService();

  // Data
  final RxList<User> users = <User>[].obs;
  List<User> get filteredUsers => users;

  final RxList<ApplyLeaveRequest> leaveRequestsList =
      <ApplyLeaveRequest>[].obs;
  List<ApplyLeaveRequest> get filteredLeaveRequestsList =>
      leaveRequestsList;

  final RxList<AttendanceActivity> attendanceList =
      <AttendanceActivity>[].obs;
  List<AttendanceActivity> get filteredAttendanceList =>
      attendanceList;


  String get _todayDateString =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  static const String _lateCutoffTime = '10:00:00';

  // === DASHBOARD METRICS ===

  int get totalEmployees => users.length;

  int get presentToday {
    final todayAttendance = attendanceList.where(
          (a) => a.punchDate == _todayDateString && a.punchType == 'IN',
    );
    return todayAttendance.map((a) => a.userKey).toSet().length;
  }

  int get lateArrivalsToday {
    final todayInPunches = attendanceList.where(
          (a) => a.punchDate == _todayDateString && a.punchType == 'IN',
    );

    final lateUserKeys = todayInPunches
        .where((a) {
      if (a.punchTime == null) return false;
      return a.punchTime!.compareTo(_lateCutoffTime) > 0;
    })
        .map((a) => a.userKey)
        .toSet();

    return lateUserKeys.length;
  }

  int get onLeaveToday => leaveRequestsList.where(
        (l) => l.leaveStatus == AppStrings.approvedStatusKey,
  ).length;

  int get pendingLeaves => leaveRequestsList.where(
        (l) => l.leaveStatus == AppStrings.pendingStatusKey,
  ).length;

  List<dynamic> get recentActivityList {
    final activity = <dynamic>[
      ...attendanceList.take(5),
      ...leaveRequestsList.where(
            (l) => l.leaveStatus == AppStrings.pendingStatusKey,
      ),
    ];

    activity.sort((a, b) {
      DateTime dateA =
          DateTime.tryParse(a.createdDate ?? '') ?? DateTime(1900);
      DateTime dateB =
          DateTime.tryParse(b.createdDate ?? '') ?? DateTime(1900);
      return dateB.compareTo(dateA);
    });

    return activity.take(8).toList();
  }

  @override
  void onInit() {
    super.onInit();
    refreshAllData();
  }

  Future<void> refreshHome() async {
    await refreshAllData();
  }

  Future<void> refreshAllData() async {

    // Clear old data so UI can rely on loading state
    users.clear();
    attendanceList.clear();
    leaveRequestsList.clear();

    try {
      await Future.wait([
        _loadUsersList(),
        _loadAllAttendanceList(),
        _loadAllLeavesRequestList(),
      ]);
    } finally {
    }
  }

  Future<void> _loadUsersList() async {

    print('_loadUsersList called');

    try {
      final res = await _service.fetchUsersList();
      print('res iseth $res');
      print('user list si h$users');

      users
        ..clear()
        ..addAll(res.map((e) => User.fromJson(e)));
      users.refresh();
    } catch (e) {
      print('AdminHomeController _loadUsersList error: $e');
    }
  }

  Future<void> _loadAllAttendanceList() async {
    try {
      final res = await _service.fetchAttendanceList();
      attendanceList
        ..clear()
        ..addAll(res.map((e) => AttendanceActivity.fromJson(e)));
      attendanceList.refresh();
    } catch (e) {
      print('AdminHomeController _loadAllAttendanceList error: $e');
    }
  }

  Future<void> _loadAllLeavesRequestList() async {
    try {
      final res = await _service.fetchLeavesList();
      leaveRequestsList
        ..clear()
        ..addAll(res.map((e) => ApplyLeaveRequest.fromJson(e)));
      leaveRequestsList.refresh();
    } catch (e) {
      print('AdminHomeController _loadAllLeavesRequestList error: $e');
    }
  }
}
