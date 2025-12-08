import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../modules/admin/binding/admin_root_binding.dart';
import '../modules/admin/views/admin_dashboard_screen.dart';
import '../modules/auth/controller/auth_controller.dart';
import '../modules/auth/views/login_screen.dart';
import '../modules/common/views/settings_screen.dart';
import '../modules/common/views/splash_screen.dart';
import '../modules/user/bindings/user_root_binding.dart';
import '../modules/user/views/user_dashboard_screen.dart';
import 'app_routes.dart';

class RoleMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>(); // NOW SAFE
    if (!auth.isLoggedIn) return RouteSettings(name: AppRoutes.login);
    return null;
  }
}



class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginScreen()),
    GetPage(name: AppRoutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRoutes.settingsScreen, page: () => SettingsScreen(), middlewares: [RoleMiddleware()]),

    GetPage(
      name: AppRoutes.userDashboard,
      page: () => const UserDashboardScreen(),
      binding: UserRootBinding(),
    ),

    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminRootBinding(),
    ),


  ];
}
