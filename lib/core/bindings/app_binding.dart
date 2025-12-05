import 'package:attedance_management_system/controller/admin_controller.dart';
import 'package:attedance_management_system/controller/common_controller.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/settings_controller.dart';
import '../../controller/user_controller.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(AdminController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    Get.put(UserController(), permanent: true);
    Get.put(CommonController(), permanent: true);

  }
}
