import 'package:attedance_management_system/views/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../views/admin/admin_dashboard_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/user/user_dashboard_screen.dart';
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
    GetPage(name: AppRoutes.adminDashboard, page: () => AdminDashboardScreen(), middlewares: [RoleMiddleware()]),
    GetPage(name: AppRoutes.userDashboard, page: () => UserDashboard(), middlewares: [RoleMiddleware()]),


  ];
}
