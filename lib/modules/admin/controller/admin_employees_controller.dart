import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';

import '../../../widgets/common/ui_helper_widgets.dart';
import '../../common/controller/loading_controller.dart';
import '../../models/user.dart';
import '../model/add_leaves_by_admin.dart';
import '../services/admin_employees_service.dart';

class AdminEmployeesController extends GetxController {
  final AdminEmployeesService _service = AdminEmployeesService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final RxBool isLeavesHistoryLoaded = false.obs;

  final RxList<User> users = <User>[].obs;
  List<User> get filteredUsers => users;

  final RxList<AddLeavesByAdmin> addedLeavesByAdmin = <AddLeavesByAdmin>[].obs;
  List<AddLeavesByAdmin> get filteredAddedLeavesByAdmin => addedLeavesByAdmin;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // loadUsers();
    });
  }

  Future<void> refreshEmployees() async {
    await loadUsers();
    await getAllAddedLeavesByAdmin();
  }

  Future<void> loadUsers() async {
    users.clear();
    _loadingController.show();

    try {
      final res = await _service.fetchUsersList();
      if (!AppHelper.isEmptyOrNull(res)) {
        users.addAll(res.map((e) => User.fromJson(e)));
        users.refresh();
      }
    } catch (e) {
      print('AdminEmployeesController.loadUsers error: $e');
    } finally {
      _loadingController.hide();
    }
  }

  Future<User?> addUser(User user) async {
    _loadingController.start();

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
      _loadingController.hide();

    }
  }

  Future<User?> updateUser(String key, User user) async {
    _loadingController.start();

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
      _loadingController.hide();

    }
  }

  Future<bool> deleteUser(String key) async {
    _loadingController.start();

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
      _loadingController.hide();

    }
  }


  Future<bool?> changeUserPasswordByAdmin(String userKey, String newPassword) async {

    print('change pass called');

    if (userKey.isEmpty) {
      Get.snackbar('Error', 'Unable to identify current user. Please login again.');
      return false;
    }

    if (newPassword.trim().length < 6) {
      Get.snackbar('Validation', 'Password must be at least 6 characters long.');
      return false;
    }

    _loadingController.start();

    try {
      final resp = await _service.changeUserPasswordByAdmin(userKey, newPassword.trim());

      if(resp != null && resp.isNotEmpty){

        UIHelper.showSnackbar(
          'Success',
          'Password Updated Successfully',
          duration: const Duration(seconds: 7),
        );

        return true;
      }
      return false;
    } catch (err) {
      Get.snackbar('Error', err.toString());
    } finally {
      _loadingController.hide();
    }
    return null;
  }



  Future<AddLeavesByAdmin?> addLeavesByAdmin(AddLeavesByAdmin addLeavesByAdmin) async {
    _loadingController.start();

    try {
      final res = await _service.addLeavesByAdmin(addLeavesByAdmin.toJson());
      if (res != null) {
        final newUser = AddLeavesByAdmin.fromJson(res);
        addedLeavesByAdmin.insert(0, newUser);
        addedLeavesByAdmin.refresh();
        return newUser;
      }
      return null;
    } catch (e) {
      print('AdminEmployeesController.addUser error: $e');
      return null;
    } finally {
      _loadingController.hide();
    }
  }

  Future<void> getAllAddedLeavesByAdmin() async {
    isLeavesHistoryLoaded.value = false;
    addedLeavesByAdmin.clear();
    _loadingController.show();

    try {
      final res = await _service.getAllAddedLeavesByAdmin();
      if (!AppHelper.isEmptyOrNull(res)) {
        addedLeavesByAdmin.addAll(res.map((e) => AddLeavesByAdmin.fromJson(e)));
        addedLeavesByAdmin.refresh();
      }
    } catch (e) {
      print('AdminEmployeesController.loadUsers error: $e');
    } finally {
      isLeavesHistoryLoaded.value = true; // ✅ IMPORTANT
      _loadingController.hide();
    }
  }


}

