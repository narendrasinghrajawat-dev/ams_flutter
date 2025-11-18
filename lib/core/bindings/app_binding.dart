import 'package:get/get.dart';

import '../../modules/auth/auth_controller.dart';
import '../../modules/settings/settings_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
