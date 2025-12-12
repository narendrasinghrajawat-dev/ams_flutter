import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/services/storage_service.dart';
import '../../../core/constants/const_strings.dart';

class SettingsController extends GetxController {
  final StorageService _storage = StorageService();

  // Reactive values used across the app
  final RxBool isDark = false.obs;
  final RxString language = 'en'.obs;
  final RxBool autoLogin = false.obs;

  // storage keys - reuse AppStrings constants
  static const String _kIsDark = AppStrings.darkModeKey;
  static const String _kLanguage = AppStrings.languageModeKey;
  static const String _kAutoLogin = AppStrings.autoLoginKey;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  /// Load saved preferences and apply theme/locale immediately
  void loadSettings() {
    final sDark = _storage.readString(_kIsDark);
    if (sDark != null) isDark.value = sDark == 'true';

    final lang = _storage.readString(_kLanguage);
    print('land is teh $lang');

    if (lang != null && lang.isNotEmpty) language.value = lang;

    final auto = _storage.readString(_kAutoLogin);
    if (auto != null) autoLogin.value = auto == 'true';

    // Apply immediately
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    Get.updateLocale(Locale(language.value));
  }

  // Toggle + persist helpers
  void setDark(bool v) {
    isDark.value = v;
    _storage.saveString(_kIsDark, v ? 'true' : 'false');
    Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
  }

  void setLanguage(String lang) {
    language.value = lang;
    _storage.saveString(_kLanguage, lang);
    Get.updateLocale(Locale(lang));
  }

  void setAutoLogin(bool v) {
    autoLogin.value = v;
    _storage.saveString(_kAutoLogin, v ? 'true' : 'false');
  }

  /// Clear all settings (optional)
  Future<void> clearAll() async {
    _storage.remove(_kIsDark);
    _storage.remove(_kLanguage);
    _storage.remove(_kAutoLogin);
    // reset local values
    isDark.value = false;
    language.value = 'en';
    autoLogin.value = false;
    Get.changeThemeMode(ThemeMode.light);
    Get.updateLocale(Locale(language.value));
  }
}
