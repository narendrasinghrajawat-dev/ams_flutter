import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/widgets/common/get_snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../services/user_profile_service.dart';

class UserProfileController extends GetxController {
  final UserProfileService _service = UserProfileService();

  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.value = AppHelper.getProfileUser();
  }

  /// Refresh local profile from storage/helper
  Future<void> refreshProfile() async {
    user.value = AppHelper.getProfileUser();
  }

  /// Change password for the current user.
  /// - newPassword: plain text (validated before calling)
  Future<bool?> changePassword(String newPassword) async {

    print('change pass called');

    final u = user.value;
    print('u is teh $u');
    if (u == null || (u.key ?? '').isEmpty) {
      Get.snackbar('Error', 'Unable to identify current user. Please login again.');
      return false;
    }

    if (newPassword.trim().length < 6) {
      Get.snackbar('Validation', 'Password must be at least 6 characters long.');
      return false;
    }

    try {
      final resp = await _service.changePassword(u.key!, newPassword.trim());

      if(resp != null && resp.isNotEmpty){

        UIHelper.showSnackbar(
          'Success',
          'Password Updated Successfully"',
          duration: const Duration(seconds: 7),
        );

        return true;
      }
      return false;
    } catch (err) {
      Get.snackbar('Error', err.toString());
    } finally {
    }
    return null;
  }
}
