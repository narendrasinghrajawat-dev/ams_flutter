// lib/modules/user/user_controller.dart
import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/api_endpoints.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/services/storage_service.dart';
import 'package:flutter/material.dart';

import '../models/punch.dart';
import '../services/user/user_services.dart';

/// Controller to handle user punch in / punch out flows.
/// Use Get.find<UserController>() to access this controller in UI.
class UserController extends GetxController {
  final UserService _service = UserService();
  final StorageService _storage = StorageService();

  // reactive state
  final RxBool isLoading = false.obs;
  final RxString currentStatus = ''.obs; // "checked_in" / "checked_out" / ''
  final RxList<Punch> lastPunches = <Punch>[].obs;

  @override
  void onInit() {
    super.onInit();
    // optional: load last punches from API/local storage
    fetchLastPunches();
  }

  /// Fetch recent punches (last X entries).
  Future<void> fetchLastPunches({int limit = 10}) async {
    try {
      isLoading.value = true;
      final res = await _service.fetchPunches(limit: limit);
      if (res != null && res is List) {
        lastPunches.value = res.map((e) => Punch.fromJson(e)).toList();
        // set status based on latest entry
        if (lastPunches.isNotEmpty) {
          final latest = lastPunches.first;
          currentStatus.value = latest.punchType?.toLowerCase() == 'checkin' ? 'checked_in' : 'checked_out';
        } else {
          currentStatus.value = '';
        }
      }
    } catch (e) {
      // silently ignore or show error
      Get.snackbar('Error', 'Failed to load punches');
    } finally {
      isLoading.value = false;
    }
  }

  /// Perform a punch-in.
  /// You can pass optional extras like location, device info, note, etc.
  Future<bool> punchIn(Punch punchInData) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final res = await _service.punch(punchInData);
      // res expected to be created punch object (map)
      if (res != null) {
        final punch = Punch.fromJson(res);
        lastPunches.insert(0, punch);
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
  Future<bool> punchOut(Punch punchOutData) async {
    if (isLoading.value) return false;
    isLoading.value = true;

    try {
      final res = await _service.punch(punchOutData);
      if (res != null ) {
        final punch = Punch.fromJson(res);
        lastPunches.insert(0, punch);
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
    lastPunches.clear();
    currentStatus.value = '';
  }
}
