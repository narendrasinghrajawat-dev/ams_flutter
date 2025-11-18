import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../modules/auth/auth_controller.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/auth/login_screen.dart';
import '../screens/user/user_dashboard.dart';
import 'app_routes.dart';

class RoleMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();
    if (!auth.isLoggedIn) return RouteSettings(name: AppRoutes.login);
    // allow route, but additional checks can be added
    return null;
  }
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(
        name: AppRoutes.adminDashboard,
        page: () => AdminDashboard(),
        middlewares: [RoleMiddleware()]),
    GetPage(
        name: AppRoutes.userDashboard,
        page: () => UserDashboard(),
        middlewares: [RoleMiddleware()]),
  ];
}
