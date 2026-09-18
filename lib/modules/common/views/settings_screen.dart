import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
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
  final StorageService _storage = StorageService();

  final RxBool _clearing = false.obs;
  final String _appVersion = AppStrings.appVersion;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: AppTextWidget.large('Settings'.tr),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Appearance & Localization
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: AppTextWidget.small(
                'APPEARANCE & PREFERENCES',
                color: AppThemeColors.muted,
              ),
            ),
            CommonCardWidget(
              padding: 0,
              child: Column(
                children: [
                  // Dark Mode Switch
                  _SettingRow(
                    icon: _settings.isDark.value ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    iconColor: _settings.isDark.value ? const Color(0xFF818CF8) : const Color(0xFFF59E0B),
                    title: 'dark_mode'.tr,
                    subtitle: 'dark_mode_sub'.tr,
                    trailing: Switch.adaptive(
                      value: _settings.isDark.value,
                      onChanged: (v) => _settings.setDark(v),
                      activeColor: AppThemeColors.primaryColor,
                    ),
                  ),
                  Divider(height: 1, color: AppThemeColors.dividerColor.withOpacity(0.5)),

                  // Language
                  _SettingRow(
                    icon: Icons.language_rounded,
                    iconColor: AppThemeColors.primaryColor,
                    title: 'language'.tr,
                    subtitle: 'language_sub'.tr,
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppThemeColors.borderColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _settings.language.value,
                          isDense: true,
                          dropdownColor: AppThemeColors.cardBackgroundColor,
                          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppThemeColors.iconColor, size: 20),
                          onChanged: (lang) {
                            if (lang != null) _settings.setLanguage(lang);
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'en',
                              child: Text(
                                'English',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppThemeColors.textPrimaryColor,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'hi',
                              child: Text(
                                'हिन्दी',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppThemeColors.textPrimaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, color: AppThemeColors.dividerColor.withOpacity(0.5)),

                  // Auto-login
                  _SettingRow(
                    icon: Icons.lock_clock_rounded,
                    iconColor: const Color(0xFF10B981),
                    title: 'auto_login'.tr,
                    subtitle: 'auto_login_sub'.tr,
                    trailing: Switch.adaptive(
                      value: _settings.autoLogin.value,
                      onChanged: (v) => _settings.setAutoLogin(v),
                      activeColor: AppThemeColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Section 2: System & Info
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: AppTextWidget.small(
                'SYSTEM & ABOUT',
                color: AppThemeColors.muted,
              ),
            ),
            CommonCardWidget(
              padding: 0,
              child: Column(
                children: [
                  // App Version
                  _SettingRow(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF64748B),
                    title: 'app_version'.tr,
                    subtitle: 'AMS Mobile Client',
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppThemeColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'v$_appVersion',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppThemeColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 1, color: AppThemeColors.dividerColor.withOpacity(0.5)),

                  // Clear Cache
                  _SettingRow(
                    icon: Icons.cleaning_services_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'clear_cache'.tr,
                    subtitle: 'clear_cache_sub'.tr,
                    trailing: _clearing.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: AppThemeColors.iconColor, size: 20),
                            onPressed: () {
                              _clearing.value = true;
                              Future.delayed(const Duration(milliseconds: 600), () {
                                _clearing.value = false;
                                Get.snackbar(
                                  'Cache Cleared',
                                  'Local cache cleared successfully',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: AppThemeColors.cardBackgroundColor,
                                  colorText: AppThemeColors.textPrimaryColor,
                                );
                              });
                            },
                          ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppThemeColors.errorColor.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: OutlinedButton.icon(
                onPressed: () {
                  if (Get.isRegistered<AuthController>()) {
                    final auth = Get.find<AuthController>();
                    auth.logout();
                  } else {
                    _storage.remove(AppStrings.profileJson);
                    _storage.remove(AppStrings.token);
                    Get.offAllNamed(AppRoutes.login);
                  }
                },
                icon: Icon(Icons.logout_rounded, color: AppThemeColors.errorColor, size: 20),
                label: Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.errorColor,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppThemeColors.errorColor.withOpacity(0.06),
                  side: BorderSide(color: AppThemeColors.errorColor.withOpacity(0.4), width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingRow({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppThemeColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppThemeColors.muted,
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
