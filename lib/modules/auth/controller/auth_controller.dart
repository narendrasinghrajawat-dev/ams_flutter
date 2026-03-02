import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../common/controller/loading_controller.dart';
import '../../common/services/storage_service.dart';
import '../../models/login.dart';
import '../../models/user.dart';
import '../services/auth_services.dart';

class AuthController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final StorageService _storage = StorageService();
  final LoadingController _loadingController = Get.find<LoadingController>();

  final Rxn<User> currentUser = Rxn<User>();

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.roleId == AppStrings.appRoleAdminId;

// Change the signature to accept the Login model
// Change the signature to accept the Login model
  Future<void> login(Login loginPayload) async {
    _loadingController.start();
    try {
      // Call your service
      final res = await _authServices.login(loginPayload);

        print('res is the $res');

      if (res != null && res.isNotEmpty) {
        // If your API follows `{ data: {...}, token: ... }` format
        final data = res['data'] ?? res;

        // Convert response to User model
        final user = User.fromJson(data);

        print('user is teh ${user.toJson()}');

        currentUser.value = user;

        // Save profile locally
        _storage.saveMap(AppStrings.profileJson, user.toJson());

        // Save token if provided
        if (res['token'] != null) {
          _storage.saveString(AppStrings.token, res['token']);
        }

        // Redirect user based on role
        if (isAdmin) {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else {
          Get.offAllNamed(AppRoutes.userDashboard);
        }
      } else {
        // If server returned error structure or empty map
        // Get.snackbar('Error', res['message'] ?? 'Login failed');
      }

    } catch (e) {
      // Catch any exceptions (network failures, parsing errors, etc.)
      Get.snackbar('Error', e.toString());

    } finally {
      // ALWAYS hide loader even when errors happen
      _loadingController.hide();
    }
  }


  void loadFromStorage() {
    final map = _storage.readMap(AppStrings.profileJson);
    if (map != null) currentUser.value = User.fromJson(map);
  }

  void logout() {
    _storage.remove(AppStrings.profileJson);
    _storage.remove(AppStrings.token);
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
  }
}
