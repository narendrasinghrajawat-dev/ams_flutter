import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:get/get.dart';

import '../../common/services/storage_service.dart';
import '../../models/login.dart';
import '../../models/user.dart';
import '../services/auth_services.dart';

class AuthController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final StorageService _storage = StorageService();

  final Rxn<User> currentUser = Rxn<User>();
  final RxBool loading = false.obs;

  bool get isLoggedIn => currentUser.value != null;
  bool get isAdmin => currentUser.value?.role == AppStrings.appRoleAdmin;

// Change the signature to accept the Login model
  Future<void> login(Login loginPayload) async {
    loading.value = true;

    // Call the service, passing the JSON representation of the Login model
    final res = await _authServices.login(loginPayload);

    loading.value = false;

    if (res.isNotEmpty) {
      // expected res['data'] contains user profile and token
      final data = res; // Assuming the server response wraps data in a 'data' key
      final user = User.fromJson(data);
      currentUser.value = user;
      _storage.saveMap(AppStrings.profileJson, user.toJson());

      // token save if provided
      if (data['token'] != null) {
        _storage.saveString(AppStrings.token, data['token']);
      }

      // redirect based on role
      if (isAdmin) {
        Get.offAllNamed(AppRoutes.adminDashboard);
      } else {
        Get.offAllNamed(AppRoutes.userDashboard);
      }
    } else {
      Get.snackbar('Error', res['message'] ?? 'Login failed');
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
