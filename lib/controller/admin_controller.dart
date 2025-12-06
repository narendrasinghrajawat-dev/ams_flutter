import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/models/admin_action.dart';
import 'package:attedance_management_system/models/apply_leave_request.dart';
import 'package:attedance_management_system/models/attendance_activity.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/models/user.dart';
import 'package:attedance_management_system/services/admin/admin_services.dart';
import 'package:intl/intl.dart';

class AdminController extends GetxController {
  final AdminServices _adminServices = AdminServices();

  RxList<User> users = <User>[].obs;
  List<User> get filteredUsers => users;

  final RxList<ApplyLeaveRequest> leaveRequestsList = <ApplyLeaveRequest>[].obs;
  List<ApplyLeaveRequest> get filteredLeaveRequestsList => leaveRequestsList;


  final RxList<AttendanceActivity> attendanceList = <AttendanceActivity>[].obs;
  List<AttendanceActivity> get filteredAttendanceList => attendanceList;



  String get _todayDateString => DateFormat('yyyy-MM-dd').format(DateTime.now());

  static const String _lateCutoffTime = '10:00:00';

  int get totalEmployees => users.length;

  // 2. Present Today Calculation
  int get presentToday {
    final todayAttendance = attendanceList.where(
          (a) => a.punchDate == _todayDateString && a.punchType == 'IN',
    );
    // Count unique users who punched in today
    return todayAttendance.map((a) => a.userKey).toSet().length;
  }

  // 3. Late Arrivals Calculation
  int get lateArrivalsToday {
    // 1. Filter for all 'IN' punches made today
    final todayInPunches = attendanceList.where(
          (a) => a.punchDate == _todayDateString && a.punchType == 'IN',
    );

    // 2. Identify late users
    final lateUserKeys = todayInPunches
        .where((a) {
      // We only check the time string for simplicity
      if (a.punchTime == null) return false;

      // This compares '09:05:00' > '09:00:00'
      return a.punchTime!.compareTo(_lateCutoffTime) > 0;
    })
        .map((a) => a.userKey)
        .toSet(); // Get unique user keys

    return lateUserKeys.length;
  }

  // 4. On Leave Today (Logic remains the same, assuming status codes are used)
  int get onLeaveToday => leaveRequestsList.where(
        (l) => l.leaveStatus == AppStrings.approvedStatusKey,
  ).length;

  // 5. Pending Leaves (Logic remains the same)
  int get pendingLeaves => leaveRequestsList.where(
        (l) => l.leaveStatus == AppStrings.pendingStatusKey,
  ).length;



  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsersList();
    _loadAllAttendanceList();
    _loadAllLeavesRequestList();
  }


  List<dynamic> get recentActivityList {
    final activity = <dynamic>[
      // Limit attendance to 5 recent items
      ...attendanceList.take(5),
      // Include pending leaves as activity
      ...leaveRequestsList.where((l) => l.leaveStatus == AppStrings.pendingStatusKey),
    ];

    // Sort all activities by creation date (most recent first)
    activity.sort((a, b) {
      DateTime dateA = DateTime.tryParse(a.createdDate ?? '') ?? DateTime(1900);
      DateTime dateB = DateTime.tryParse(b.createdDate ?? '') ?? DateTime(1900);
      return dateB.compareTo(dateA); // Descending order
    });

    return activity.take(8).toList(); // Return top 8 items
  }

  _loadUsersList() async {

    loading.value = true;
    try {
      final List<Map<String, dynamic>> res = await _adminServices.fetchUsersList();
      if (!AppHelper.isEmptyOrNull(res)) {
        users.clear();
        for (var item in res) {
          final user = User.fromJson(item);
          users.add(user);
        }
      }
    } catch (e) {
      print('Error loading users: $e');
    } finally {
      loading.value = false;
    }
  }

  _loadAllAttendanceList() async {

    try {
      final List<Map<String, dynamic>> res = await _adminServices.fetchAttendanceList();
      if (!AppHelper.isEmptyOrNull(res)) {
        attendanceList.clear();
        for (var item in res) {
          final user = AttendanceActivity.fromJson(item);
          attendanceList.add(user);
        }
        attendanceList.refresh();
      }
    } catch (e) {
      print('Error loading users: $e');
    } finally {
      loading.value = false;
    }
  }

  _loadAllLeavesRequestList() async {

    try {
      final List<Map<String, dynamic>> res = await _adminServices.fetchLeavesList();
      if (!AppHelper.isEmptyOrNull(res)) {
        leaveRequestsList.clear();
        for (var item in res) {
          final user = ApplyLeaveRequest.fromJson(item);
          leaveRequestsList.add(user);
        }
        leaveRequestsList.refresh();
      }
    } catch (e) {
      print('Error loading users: $e');
    } finally {
      loading.value = false;
    }
  }


  /// Add a new user: calls service, on success insert into users list and return created User.
  Future<User?> addUser({required User user }) async {

    print('add user called with user ${user.toJson()}');

    loading.value = true;
    try {
      final res = await _adminServices.createUser(user.toJson());

      print('admin cotroller response isthe ');
      print(res);

      if (res != null) {
        final newUser = User.fromJson(res);
        // Insert at top
        print('before add ing ${users.length}');
        users.insert(0, newUser);
        print('after add ing ${users.length}');

        users.refresh();
        return newUser;
      } else {
        return null;
      }
    } catch (e) {
      print('Add user error: $e');
      return null;
    } finally {
      loading.value = false;
    }
  }

  /// Update an existing user.
  /// Returns updated User on success, null on failure.
  Future<User?> updateUser(String key, User user) async {
    loading.value = true;
    try {
      final res = await _adminServices.updateUser(key, user.toJson());
      if (res != null) {
        final updated = User.fromJson(res);
        final idx = users.indexWhere((u) => u.key == key);
        if (idx != -1) {
          users[idx] = updated;
        } else {
          // If not found locally, add it
          users.insert(0, updated);
        }
        users.refresh();
        return updated;
      }
      return null;
    } catch (e) {
      print('Update user error: $e');
      return null;
    } finally {
      loading.value = false;
    }
  }

  /// Delete a user by id. Returns true on success.
  Future<bool> deleteUser(String key) async {
    print('delete user start $key');
    loading.value = true;
    try {
      final ok = await _adminServices.deleteUser(key);

      print('ok is start $ok');

      if (ok) {
        users.removeWhere((u) => u.key == key);
        users.refresh();
        return true;
      }
      return false;
    } catch (e) {
      print('Delete user error: $e');
      return false;
    } finally {
      loading.value = false;
    }
  }
// ... inside AdminController ...

// --- UPDATED FUNCTIONS ---



  Future<void> approveLeave(AdminAction payload) async {
    print('approveLeave called');
    print(payload.toJson());

    // Directly call the service with the complete payload
    final updatedRequest = await _adminServices.adminActionOnLeave(payload);

    // 1. Update the local list if the backend update was successful
    if (updatedRequest != null) {
      final idx = leaveRequestsList.indexWhere((l) => l.key == payload.leavesId);
      if (idx != -1) {
        // Use the data returned from the backend (updatedRequest) for a precise refresh
        leaveRequestsList[idx] = updatedRequest;
        leaveRequestsList.refresh();
      }
    }
  }

  Future<void> rejectLeave(AdminAction payload) async {
    print('rejectLeave called');
    print(payload.toJson());

    // Directly call the service with the complete payload
    final updatedRequest = await _adminServices.adminActionOnLeave(payload);

    // 1. Update the local list if the backend update was successful
    if (updatedRequest != null) {
      final idx = leaveRequestsList.indexWhere((l) => l.key == payload.leavesId);
      if (idx != -1) {
        // Use the data returned from the backend (updatedRequest) for a precise refresh
        leaveRequestsList[idx] = updatedRequest;
        leaveRequestsList.refresh();
      }
    }
  }



}
