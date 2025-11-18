import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/settings_controller.dart';


class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
