import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:get/get.dart';

import '../../models/user.dart';
import '../services/user_profile_service.dart';

class UserProfileController extends GetxController {
  final UserProfileService _service = UserProfileService();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = AppHelper.getProfileUser();
  }

  Future<void> refreshProfile() async {
    // if you add API to fetch profile from backend
    // final data = await _service.fetchProfile();
    // user.value = data;
  }

  Future<bool> updateProfile(User updated) async {
    isSaving.value = true;
    try {
      final ok = await _service.updateProfile(updated);
      if (ok) {
        user.value = updated;
      }
      return ok;
    } finally {
      isSaving.value = false;
    }
  }
}
