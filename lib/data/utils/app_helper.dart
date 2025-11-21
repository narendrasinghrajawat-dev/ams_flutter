
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/services/storage_service.dart';

import '../../models/user.dart';

class AppHelper {

  static StorageService storageService = StorageService();

  static bool isEmptyOrNull(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.trim().isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }

    if (value is Iterable) {
      return value.isEmpty;
    }
    return false;
  }

  static User getProfileUser(){
    return User.fromJson(storageService.readMap(AppStrings.profileJson)!);
  }




}
