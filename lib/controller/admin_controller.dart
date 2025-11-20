import 'package:get/get.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/models/user.dart';
import 'package:attedance_management_system/models/leave_request.dart';
import 'package:attedance_management_system/services/admin/admin_services.dart';

class AdminController extends GetxController {
  RxList<User> users = <User>[].obs;
  final RxList<LeaveRequest> leaveRequests = <LeaveRequest>[].obs;
  final AdminServices _adminServices = AdminServices();

  final RxBool loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUsersList();
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

  List<User> get filteredUsers => users;

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

  void approveLeave(String id) {
    final idx = leaveRequests.indexWhere((l) => l.id == id);
    if (idx != -1) {
      leaveRequests[idx].status = 'approved';
      leaveRequests.refresh();
    }
  }

  void rejectLeave(String id) {
    final idx = leaveRequests.indexWhere((l) => l.id == id);
    if (idx != -1) {
      leaveRequests[idx].status = 'rejected';
      leaveRequests.refresh();
    }
  }
}
