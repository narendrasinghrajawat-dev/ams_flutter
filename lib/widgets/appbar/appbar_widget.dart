import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../modules/models/user.dart';
import '../../routes/app_routes.dart';
import '../text_and_icon_widgets/app_icon_button.dart';
import '../text_and_icon_widgets/app_text_type.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  const UserAppBar({
    required this.user,
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(74.0);

  String get _fullName {
    final middle = user.middleName == null || user.middleName!.isEmpty ? '' : ' ${user.middleName}';
    return '${user.firstName}$middle ${user.lastName}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;

    return AppBar(
      backgroundColor: AppThemeColors.appbarBackgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      actionsPadding: EdgeInsets.zero,
      shape: Border(
        bottom: BorderSide(
          color: isDark ? AppThemeColors.borderColor : Colors.transparent,
          width: 1,
        ),
      ),
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppThemeColors.primaryColor : Colors.white.withOpacity(0.8),
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white.withOpacity(0.2),
                    radius: 20,
                    child: Text(
                      user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget.medium(
                      _fullName,
                      maxLines: 1,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 2),
                    AppTextWidget.verySmall(
                      user.email,
                      maxLines: 1,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ],
                ),
              ),
              AppIconButtonWidget.large(
                icon: AppConstIcons.settingsIcon,
                color: Colors.white,
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.toNamed(AppRoutes.settingsScreen);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}