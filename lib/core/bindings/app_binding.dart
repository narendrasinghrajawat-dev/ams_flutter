import 'package:get/get.dart';

import '../../modules/auth/controller/auth_controller.dart';
import '../../modules/common/controller/common_controller.dart';
import '../../modules/common/controller/loading_controller.dart';
import '../../modules/common/controller/settings_controller.dart';



class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    // Get.put(AdminController(), permanent: true);
    Get.put(SettingsController(), permanent: true);
    // Get.put(UserController(), permanent: true);
    Get.put(CommonController(), permanent: true);

  }
}
