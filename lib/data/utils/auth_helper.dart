

// lib/core/helpers/app_helper.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller.dart';
import '../../core/constants/const_strings.dart';
import '../../models/user.dart';
import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';


class AuthHelper {
  static Future<void> checkAndRedirect({bool replaceAll = true}) async {
    final storage = StorageService();
    final authCtrl = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());

    // read saved profile map from storage (if any)
    final Map<String, dynamic>? savedUserMap = storage.readMap(AppStrings.profileJson);

    // small helper to navigate with animation
    void _navigate(String routeName, Transition transition) {
      if (replaceAll) {
        Get.offAllNamed(routeName,);
      } else {
        Get.toNamed(routeName,);
      }
    }

    // No user saved -> go to login
    if (savedUserMap == null) {
      _navigate(AppRoutes.login, Transition.fade);
      return;
    }

    // Try to restore user into AuthController
    try {
      // store user in controller (this also ensures currentUser is populated)
      authCtrl.currentUser.value = User.fromJson(savedUserMap);
    } catch (e) {
      // if parsing fails, clear storage and go to login
      storage.remove(AppStrings.profileJson);
      storage.remove(AppStrings.token);
      _navigate(AppRoutes.login, Transition.fade);
      return;
    }

    // Optionally you could also load token or refresh token here
    final token = storage.readString(AppStrings.token);
    if (token != null) {
      // you may set token into api client here if you use one
    }

    // Decide role-based routing
    final role = authCtrl.currentUser.value?.role?.toLowerCase() ?? 'user';
    if (role == 'admin' || role == 'administrator') {
      // Admin — slide from top (visible emphasis)
      _navigate(AppRoutes.adminDashboard, Transition.downToUp);
    } else {
      // Regular user — slide from right
      _navigate(AppRoutes.userDashboard, Transition.rightToLeft);
    }
  }

}