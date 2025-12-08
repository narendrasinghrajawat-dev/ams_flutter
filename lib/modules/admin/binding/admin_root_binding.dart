

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controller/admin_employees_controller.dart';
import '../controller/admin_home_controller.dart';
import '../controller/admin_leaves_controller.dart';

class AdminRootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminHomeController>(() => AdminHomeController(), fenix: true);
    Get.lazyPut<AdminEmployeesController>(() => AdminEmployeesController(), fenix: true);
    Get.lazyPut<AdminLeavesController>(() => AdminLeavesController(), fenix: true);
    // AdminProfileScreen just uses AuthController for now
  }
}
