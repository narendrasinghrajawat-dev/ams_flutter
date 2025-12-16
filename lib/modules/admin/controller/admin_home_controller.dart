import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../common/controller/loading_controller.dart';
import '../../models/apply_leave_request.dart';
import '../../models/attendance_activity.dart';
import '../../models/user.dart';
import '../services/admin_home_service.dart';




class AdminHomeController extends GetxController {
  final AdminHomeService _service = AdminHomeService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  // Data
  final RxList<User> users = <User>[].obs;
  List<User> get filteredUsers => users;

  final RxList<ApplyLeaveRequest> leaveRequestsList = <ApplyLeaveRequest>[].obs;
  List<ApplyLeaveRequest> get filteredLeaveRequestsList => leaveRequestsList;

  final RxList<AttendanceActivity> attendanceList = <AttendanceActivity>[].obs;
  List<AttendanceActivity> get filteredAttendanceList => attendanceList;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  String get selectedDateString => selectedDate.value.toIso8601String();


  static const String _lateCutoffTime = '10:00:00';

  // === DASHBOARD METRICS ===

  int get totalEmployees => users.length;

  int get presentToday {
    final selected = selectedDate.value;

    final presentUsers = attendanceList.where((a) {
      if (a.punchTime == null) return false;
      if (a.punchType != AppStrings.approvedLeavesStatusKey) return false;

      final punchDate = DateTime.tryParse(a.punchTime!);
      if (punchDate == null) return false;

      return _isSameDay(punchDate, selected);
    });

    return presentUsers.map((a) => a.userKey).toSet().length;
  }



  int get lateArrivalsToday {
    final selected = selectedDate.value;

    final lateUsers = attendanceList.where((a) {
      if (a.punchTime == null) return false;
      if (a.punchType != '1') return false;

      final punchDate = DateTime.tryParse(a.punchTime!);
      if (punchDate == null) return false;

      // Must be same selected day
      if (!_isSameDay(punchDate, selected)) return false;

      // Late check (compare time only)
      final punchTimeOnly = DateFormat('HH:mm:ss').format(punchDate);

      return punchTimeOnly.compareTo(_lateCutoffTime) > 0;
    });

    return lateUsers.map((a) => a.userKey).toSet().length;
  }



  int get onLeaveToday {
    final selected = selectedDate.value;

    // Normalize selected date to full-day range
    final dayStart = DateTime(
      selected.year,
      selected.month,
      selected.day,
      0,
      0,
      0,
    );

    final dayEnd = DateTime(
      selected.year,
      selected.month,
      selected.day,
      23,
      59,
      59,
      999,
    );

    return leaveRequestsList.where((l) {
      if (l.leaveStatus != AppStrings.approvedLeavesStatusKey) return false;
      if (l.startDate == null || l.endDate == null) return false;

      final start = DateTime.tryParse(l.startDate!);
      final end = DateTime.tryParse(l.endDate!);

      if (start == null || end == null) return false;

      // 🔥 CORRECT OVERLAP CHECK
      return start.isBefore(dayEnd) && end.isAfter(dayStart);
    }).length;
  }



  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }


  int get pendingLeaves => leaveRequestsList.where(
        (l) => l.leaveStatus == AppStrings.pendingLeavesStatusKey,
  ).length;

  List<dynamic> get recentActivityList {
    final selected = selectedDate.value;

    final activity = <dynamic>[
      // 🔹 Attendance (date-based)
      ...attendanceList.where((a) {
        if (a.punchTime == null) return false;

        final punchDate = DateTime.tryParse(a.punchTime!);
        if (punchDate == null) return false;

        return _isSameDay(punchDate, selected);
      }),

      // 🔹 Leaves (created on selected day)
      ...leaveRequestsList.where((l) {
        if (l.createdDate == null) return false;

        final created = DateTime.tryParse(l.createdDate!);
        if (created == null) return false;

        return _isSameDay(created, selected) &&
            l.leaveStatus == AppStrings.pendingLeavesStatusKey;
      }),
    ];

    activity.sort((a, b) {
      final dateA =
          DateTime.tryParse(a.createdDate ?? '') ?? DateTime(1900);
      final dateB =
          DateTime.tryParse(b.createdDate ?? '') ?? DateTime(1900);
      return dateB.compareTo(dateA);
    });

    return activity.take(8).toList();
  }


  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshAllData();
    });
  }



  /// 🔄 Called when Activity tab opens
  void resetToToday() {
    selectedDate.value = DateTime.now();
    print('reset to today');
    print(selectedDate.value);

    refreshHomeByDate();
  }


  void changeDate(DateTime date) {
    selectedDate.value = date;
    print('changeDate to today');
    print(selectedDate.value);

    refreshHomeByDate();
  }

  Future<void> refreshHomeByDate() async {
    try {
      _loadingController.start();

      await Future.wait([
        _loadUsersList(),
        _loadAllAttendanceListByDate(),
        _loadAllLeavesRequestListByDate(),
      ]);
    } finally {
      _loadingController.hide();
    }
  }

  Future<void> _loadAllAttendanceListByDate() async {
    try {
      final res = await _service.fetchAttendanceByDate(selectedDateString);

      attendanceList
        ..clear()
        ..addAll(res.map((e) => AttendanceActivity.fromJson(e)));

      attendanceList.refresh();
    } catch (e) {
      print('Attendance load error: $e');
    }
  }


  Future<void> _loadAllLeavesRequestListByDate() async {
    try {
      final res =
      await _service.fetchLeavesByDate(selectedDateString);

      leaveRequestsList
        ..clear()
        ..addAll(res.map((e) => ApplyLeaveRequest.fromJson(e)));

      leaveRequestsList.refresh();
    } catch (e) {
      print('Leaves load error: $e');
    }
  }


  Future<void> refreshHome() async {
    await refreshAllData();
  }

  Future<void> refreshAllData() async {
    users.clear();
    attendanceList.clear();
    leaveRequestsList.clear();

    try {

      await Future.wait([
        _loadUsersList(),
        _loadAllAttendanceListByDate(),
        _loadAllLeavesRequestListByDate(),
      ]);
    } finally {
    }
  }


  Future<void> _loadUsersList() async {

    print('_loadUsersList called');

    _loadingController.start();

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
    } finally{
      _loadingController.hide();
    }
  }

  // Future<void> _loadAllAttendanceList() async {
  //   _loadingController.start();
  //
  //   try {
  //     final res = await _service.fetchAttendanceList();
  //     attendanceList
  //       ..clear()
  //       ..addAll(res.map((e) => AttendanceActivity.fromJson(e)));
  //     attendanceList.refresh();
  //   } catch (e) {
  //     print('AdminHomeController _loadAllAttendanceList error: $e');
  //   } finally{
  //     _loadingController.hide();
  //   }
  // }
  //
  // Future<void> _loadAllLeavesRequestList() async {
  //   _loadingController.start();
  //
  //   try {
  //     final res = await _service.fetchLeavesList();
  //     leaveRequestsList
  //       ..clear()
  //       ..addAll(res.map((e) => ApplyLeaveRequest.fromJson(e)));
  //     leaveRequestsList.refresh();
  //   } catch (e) {
  //     print('AdminHomeController _loadAllLeavesRequestList error: $e');
  //   } finally{
  //     _loadingController.hide();
  //
  //   }
  // }



}
