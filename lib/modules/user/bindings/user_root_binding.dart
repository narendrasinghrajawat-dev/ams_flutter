
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controller/user_activity_controller.dart';
import '../controller/user_home_controller.dart';
import '../controller/user_leaves_controller.dart';
import '../controller/user_profile_controller.dart';

class UserRootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserHomeController>(() => UserHomeController(), fenix: true);
    Get.lazyPut<UserLeavesController>(() => UserLeavesController(), fenix: true);
    Get.lazyPut<UserActivityController>(() => UserActivityController(), fenix: true);
    Get.lazyPut<UserProfileController>(() => UserProfileController(), fenix: true);
  }
}
