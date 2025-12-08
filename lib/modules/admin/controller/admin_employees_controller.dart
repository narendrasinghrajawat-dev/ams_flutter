import 'package:get/get.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../models/user.dart';
import '../services/admin_employees_service.dart';

class AdminEmployeesController extends GetxController {
  final AdminEmployeesService _service = AdminEmployeesService();

  final RxList<User> users = <User>[].obs;
  List<User> get filteredUsers => users;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  Future<void> refreshEmployees() async {
    await loadUsers();
  }

  Future<void> loadUsers() async {
    users.clear();

    try {
      final res = await _service.fetchUsersList();
      if (!AppHelper.isEmptyOrNull(res)) {
        users.addAll(res.map((e) => User.fromJson(e)));
        users.refresh();
      }
    } catch (e) {
      print('AdminEmployeesController.loadUsers error: $e');
    } finally {
    }
  }

  Future<User?> addUser(User user) async {
    try {
      final res = await _service.createUser(user.toJson());
      if (res != null) {
        final newUser = User.fromJson(res);
        users.insert(0, newUser);
        users.refresh();
        return newUser;
      }
      return null;
    } catch (e) {
      print('AdminEmployeesController.addUser error: $e');
      return null;
    } finally {
    }
  }

  Future<User?> updateUser(String key, User user) async {
    try {
      final res = await _service.updateUser(key, user.toJson());
      if (res != null) {
        final updated = User.fromJson(res);
        final idx = users.indexWhere((u) => u.key == key);
        if (idx != -1) {
          users[idx] = updated;
        } else {
          users.insert(0, updated);
        }
        users.refresh();
        return updated;
      }
      return null;
    } catch (e) {
      print('AdminEmployeesController.updateUser error: $e');
      return null;
    } finally {
    }
  }

  Future<bool> deleteUser(String key) async {
    try {
      final ok = await _service.deleteUser(key);
      if (ok) {
        users.removeWhere((u) => u.key == key);
        users.refresh();
        return true;
      }
      return false;
    } catch (e) {
      print('AdminEmployeesController.deleteUser error: $e');
      return false;
    } finally {
    }
  }
}
