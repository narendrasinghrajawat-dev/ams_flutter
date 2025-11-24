import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../controller/auth_controller.dart';
import '../services/common/storage_service.dart';
import '../widgets/app_text_type.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storage = StorageService();

  // Storage keys (keep them consistent across app)
  static const _kIsDark = 'pref_is_dark';
  static const _kLanguage = 'pref_language';
  static const _kAutoLogin = 'pref_auto_login';

  final RxBool _isDark = false.obs;
  final RxString _language = 'en'.obs;
  final RxBool _autoLogin = false.obs;
  final RxBool _clearing = false.obs;

  // App version (replace with package_info_plus if desired)
  final String _appVersion = '1.0.0';
  final String _buildNumber = '100';

  @override
  void initState() {
    super.initState();
    // load prefs after first frame to avoid changing UI during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPrefs();
    });
  }

  void _loadPrefs() {
    final sDark = _storage.readString(_kIsDark);
    if (sDark != null) _isDark.value = sDark == 'true';

    final lang = _storage.readString(_kLanguage);
    if (lang != null && lang.isNotEmpty) _language.value = lang;

    final auto = _storage.readString(_kAutoLogin);
    if (auto != null) _autoLogin.value = auto == 'true';

    // Apply theme & locale immediately
    Get.changeThemeMode(_isDark.value ? ThemeMode.dark : ThemeMode.light);
    Get.updateLocale(Locale(_language.value));
  }

  void _saveBoolPref(String key, bool value) {
    _storage.saveString(key, value ? 'true' : 'false');
  }

  void _saveStringPref(String key, String value) {
    _storage.saveString(key, value);
  }

  void _onToggleDark(bool v) {
    _isDark.value = v;
    Get.changeThemeMode(v ? ThemeMode.dark : ThemeMode.light);
    _saveBoolPref(_kIsDark, v);
  }

  void _onChangeLanguage(String? lang) {
    if (lang == null) return;
    _language.value = lang;
    Get.updateLocale(Locale(lang));
    _saveStringPref(_kLanguage, lang);
  }

  Future<void> _onClearCache() async {
    _clearing.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    _storage.remove('profile_json');
    _storage.remove('auth_token');
    // if you want to clear everything: GetStorage().erase(); but use with care
    _clearing.value = false;
    Get.snackbar('Cleared', 'Cache cleared', snackPosition: SnackPosition.BOTTOM);
  }

  void _onLogout() {
    if (Get.isRegistered<AuthController>()) {
      final auth = Get.find<AuthController>();
      auth.logout();
    } else {
      // fallback: clear user & navigate to login
      _storage.remove(AppStrings.profileJson);
      _storage.remove(AppStrings.token);
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('user_dashboard'.tr),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.medium('Preferences', color: AppThemeColors.textPrimaryColor),
              const SizedBox(height: 12),

              // Dark mode toggle
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Dark Mode', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Use system-wide dark theme', color: AppThemeColors.textSecondaryColor),
                trailing: Switch.adaptive(
                  value: _isDark.value,
                  onChanged: _onToggleDark,
                  activeColor: AppThemeColors.primaryColor,
                ),
              )),

              Divider(color: AppThemeColors.dividerColor),

              // Language selection
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Language', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Select app language', color: AppThemeColors.textSecondaryColor),
                trailing: DropdownButton<String>(
                  value: _language.value,
                  underline: const SizedBox.shrink(),
                  onChanged: _onChangeLanguage,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                  ],
                ),
              )),

              Divider(color: AppThemeColors.dividerColor),

              // Auto-login / remember me
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Auto Login', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Automatically sign in on app start', color: AppThemeColors.textSecondaryColor),
                trailing: Switch.adaptive(
                  value: _autoLogin.value,
                  onChanged: (v) {
                    _autoLogin.value = v;
                    _saveBoolPref(_kAutoLogin, v);
                  },
                  activeColor: AppThemeColors.primaryColor,
                ),
              )),

              Divider(color: AppThemeColors.dividerColor),
              const SizedBox(height: 10),

              AppTextWidget.medium('Account', color: AppThemeColors.textPrimaryColor),
              const SizedBox(height: 12),

              // App version
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('App Version', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('$_appVersion ($_buildNumber)', color: AppThemeColors.textSecondaryColor),
              ),

              Divider(color: AppThemeColors.dividerColor),

              // Clear cache
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Clear Cache', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Remove temporary app data', color: AppThemeColors.textSecondaryColor),
                trailing: _clearing.value
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : IconButton(
                  icon: Icon(Icons.delete_outline, color: AppThemeColors.iconColor),
                  onPressed: _onClearCache,
                ),
              )),

              // Replaced Spacer() with fixed spacing to avoid unbounded-flex error
              const SizedBox(height: 28),

              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _onLogout,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppThemeColors.errorColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: AppTextWidget.medium('Logout', color: AppThemeColors.errorColor),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
