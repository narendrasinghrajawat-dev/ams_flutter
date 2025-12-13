
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../modules/models/user.dart';
import '../../routes/app_routes.dart';
import '../text_and_icon_widgets/app_icon_button.dart';
import '../text_and_icon_widgets/app_text_type.dart';

class UserAppBar extends StatelessWidget implements PreferredSizeWidget {
  final User user;

  UserAppBar({
    required this.user,
    super.key,
  });

// Define the preferred height for the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(80.0);

// Helper method to construct the full name
  String get _fullName {
    final middle = user.middleName == null ? '' : ' ${user.middleName}';
    return '${user.firstName}$middle ${user.lastName}';
  }

  String networkImage = 'https://t4.ftcdn.net/jpg/03/26/98/51/360_F_326985142_1aaKcEjMQW6ULp6oI9MYuv8lN9f8sFmj.jpg';
    
  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: AppThemeColors.appbarBackgroundColor,
      elevation: 0,
      actionsPadding: EdgeInsets.all(0),
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppThemeColors.primaryLightColor, width: 2.5),
                ),
                child: CircleAvatar(
                  backgroundColor: AppThemeColors.circleAvatarBackgroundColor,
                  radius: 22,
                  child: AppIconWidget.veryLarge(AppConstIcons.personIcon), // Specify the radius of the avatar, which controls its size
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
                      maxLines: 2,
                      color: AppThemeColors.whiteColor,
                    ),

                    AppTextWidget.small(
                      user.email,
                      maxLines: 2,
                      color: AppThemeColors.whiteColor,
                    ),

                  ],
                ),
              ),

              AppIconButtonWidget.large(icon: AppConstIcons.settingsIcon, color: Colors.white, onPressed: (){
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Get.toNamed(AppRoutes.settingsScreen);
                  });
                }).marginOnly(right: 10),

            ],
          ),
        ),
      ),
    );
  }
}