import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../auth/controller/auth_controller.dart';
import '../controller/settings_controller.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsController _settings = Get.find();
  final StorageService _storage = StorageService(); // optional - controller handles saves

  final RxBool _clearing = false.obs;
  final String _appVersion = AppStrings.appVersion;
  final String _buildNumber = '100';

  // no need to load prefs here - controller already loaded them
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: AppTextWidget.large('user_dashboard'.tr)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.medium('Preferences', color: AppThemeColors.textPrimaryColor),
              const SizedBox(height: 12),

              // Dark mode toggle (bind to controller)
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Dark Mode', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Use system-wide dark theme', color: AppThemeColors.textSecondaryColor),
                trailing: Switch.adaptive(
                  value: _settings.isDark.value,
                  onChanged: (v) => _settings.setDark(v),
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
                  value: _settings.language.value,
                  underline: const SizedBox.shrink(),
                  onChanged: (lang) { if (lang != null) _settings.setLanguage(lang); },
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'hi', child: Text('हिन्दी')),
                  ],
                ),
              )),

              Divider(color: AppThemeColors.dividerColor),

              // Auto-login
              Obx(() => ListTile(
                contentPadding: EdgeInsets.zero,
                title: AppTextWidget.small('Auto Login', color: AppThemeColors.textPrimaryColor),
                subtitle: AppTextWidget.verySmall('Automatically sign in on app start', color: AppThemeColors.textSecondaryColor),
                trailing: Switch.adaptive(
                  value: _settings.autoLogin.value,
                  onChanged: (v) => _settings.setAutoLogin(v),
                  activeColor: AppThemeColors.primaryColor,
                ),
              )),

              // rest of the UI unchanged...
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
                  onPressed: null,
                ),
              )),

              // Replaced Spacer() with fixed spacing to avoid unbounded-flex error
              const SizedBox(height: 28),


              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: (){
                      if (Get.isRegistered<AuthController>()) {
                        final auth = Get.find<AuthController>();
                        auth.logout();
                      } else {
                        // fallback: clear user & navigate to login
                        _storage.remove(AppStrings.profileJson);
                        _storage.remove(AppStrings.token);
                        Get.offAllNamed(AppRoutes.login);
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppThemeColors.errorColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: AppTextWidget.medium('Logout', color: AppThemeColors.errorColor),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
