import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../core/constants/const_strings.dart';
import '../../modules/models/user.dart';
import '../../routes/app_routes.dart';
import '../text_and_icon_widgets/app_text_type.dart';

class AppDrawer extends StatelessWidget {
  final User user;
  final Function(int)? onTabSelected;

  const AppDrawer({
    required this.user,
    this.onTabSelected,
    super.key,
  });

  String get _fullName {
    final middle = user.middleName == null || user.middleName!.isEmpty ? '' : ' ${user.middleName}';
    return '${user.firstName}$middle ${user.lastName}';
  }

  void _logout() {
    Get.back(); // close drawer
    Get.dialog(
      AlertDialog(
        backgroundColor: AppThemeColors.popupBackgroundColor,
        title: AppTextWidget.large('Logout'.tr, color: AppThemeColors.textPrimaryColor),
        content: AppTextWidget.medium('Are you sure you want to logout?'.tr, color: AppThemeColors.textSecondaryColor),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AppTextWidget.medium('Cancel'.tr, color: AppThemeColors.textSecondaryColor),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Get.back(); // close dialog
              Get.offAllNamed(AppRoutes.login);
            },
            child: AppTextWidget.medium('Logout'.tr, color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdmin = user.roleId == AppStrings.appRoleAdminId;

    return Drawer(
      backgroundColor: AppThemeColors.popupBackgroundColor,
      child: Column(
        children: [
          // Beautiful Custom Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 20, left: 20, right: 20),
            color: AppThemeColors.appbarBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 36, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _fullName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.countryCode} ${user.phoneNo}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Drawer Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home_outlined, color: AppThemeColors.iconColor),
                  title: AppTextWidget.medium('Home'.tr, color: AppThemeColors.textPrimaryColor),
                  onTap: () {
                    Get.back(); // close drawer
                    if (onTabSelected != null) onTabSelected!(0);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.beach_access_outlined, color: AppThemeColors.iconColor),
                  title: AppTextWidget.medium('Leaves'.tr, color: AppThemeColors.textPrimaryColor),
                  onTap: () {
                    Get.back();
                    if (onTabSelected != null) onTabSelected!(isAdmin ? 3 : 1);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.timeline_outlined, color: AppThemeColors.iconColor),
                  title: AppTextWidget.medium('Activity'.tr, color: AppThemeColors.textPrimaryColor),
                  onTap: () {
                    Get.back();
                    if (onTabSelected != null) onTabSelected!(isAdmin ? 1 : 2);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.person_outline, color: AppThemeColors.iconColor),
                  title: AppTextWidget.medium('Profile'.tr, color: AppThemeColors.textPrimaryColor),
                  onTap: () {
                    Get.back();
                    if (onTabSelected != null) onTabSelected!(isAdmin ? 4 : 3);
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Icon(Icons.settings_outlined, color: AppThemeColors.iconColor),
                  title: AppTextWidget.medium('Settings'.tr, color: AppThemeColors.textPrimaryColor),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.settingsScreen);
                  },
                ),
              ],
            ),
          ),

          // Logout Item at the bottom
          SafeArea(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: AppTextWidget.medium('Logout'.tr, color: Colors.red),
              onTap: _logout,
            ),
          ),
        ],
      ),
    );
  }
}
