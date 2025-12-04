// lib/views/user/user_profile_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/card/common_card.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';

class UserProfileScreen extends StatelessWidget {
  // local sample avatar image uploaded to container (use as demonstration)
  // developer note: this path exists in the project container and can be used in preview/dev
  static const String _demoAvatarPath = '/mnt/data/16f68a66-900b-4b85-9dc1-42eb370ef87b.png';

  const UserProfileScreen({Key? key}) : super(key: key);

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    Color? iconBg,
  }) {
    return CommonCardWidget(
      padding: 0,
        child: ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: iconBg ?? AppThemeColors.primaryLightColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppThemeColors.primaryColor),
      ),
      title: AppTextWidget.medium(title, color: AppThemeColors.textPrimaryColor),
      subtitle: subtitle != null
          ? AppTextWidget.verySmall(subtitle, color: AppThemeColors.textSecondaryColor)
          : null,
      trailing: Icon(Icons.chevron_right, color: AppThemeColors.iconColor),
    )
    ).marginOnly(bottom: 10);
  }
  static const String networkImage = 'https://t4.ftcdn.net/jpg/03/26/98/51/360_F_326985142_1aaKcEjMQW6ULp6oI9MYuv8lN9f8sFmj.jpg';

  @override
  Widget build(BuildContext context) {
    // If you have an AuthController with currentUser, use it to fill details.
    final authRegistered = Get.isRegistered<AuthController>();
    final auth = authRegistered ? Get.find<AuthController>() : null;
    final user = auth?.currentUser.value;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
        child: Column(
          children: [
            // Header: avatar + name + role + edit button
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CommonCardWidget(
                child: Column(
                  children: [
                    // avatar with camera badge
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              )
                            ],
                          ),
                          child: ClipOval(
                            child:   Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppThemeColors.primaryLightColor, width: 2.5),
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(networkImage),
                                radius: 25, // Specify the radius of the avatar, which controls its size
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 6,
                          child: GestureDetector(
                            onTap: () {
                              // open image picker
                              Get.snackbar('Info', 'Change avatar tapped');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppThemeColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppThemeColors.whiteColor, width: 2),
                              ),
                              child: Icon(Icons.camera_alt, color: AppThemeColors.whiteColor, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    AppTextWidget.large(
                      user != null ? '${user.firstName ?? ''} ${user.lastName ?? ''}' : 'Michael Mitc',
                      color: AppThemeColors.textPrimaryColor,
                    ),


                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Settings / actions list (common)
            Column(
              children: [
                _tile(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  subtitle: 'View & edit your personal details',
                  onTap: () => Get.toNamed('/profileDetails'),
                ),
                _tile(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () => Get.toNamed('/changePassword'),
                ),
                _tile(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Read app terms',
                  onTap: () => Get.toNamed('/terms'),
                ),
                _tile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Our data usage policy',
                  onTap: () => Get.toNamed('/privacy'),
                ),
                _tile(
                  icon: Icons.format_paint_outlined,
                  title: 'Change Layout',
                  subtitle: 'Switch app layout / density',
                  onTap: () => Get.toNamed('/changeLayout'),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Other quick info card
            CommonCardWidget(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.small('Contact', color: AppThemeColors.textSecondaryColor),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: AppThemeColors.iconColor),
                      const SizedBox(width: 10),
                      AppTextWidget.small(user?.email ?? 'michael@example.com', color: AppThemeColors.textPrimaryColor),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined, color: AppThemeColors.iconColor),
                      const SizedBox(width: 10),
                      AppTextWidget.small(user?.phoneNo ?? '+91 98765 43210', color: AppThemeColors.textPrimaryColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextWidget.small('Location', color: AppThemeColors.textSecondaryColor),
                  const SizedBox(height: 8),
                  AppTextWidget.small(user?.address?.street ?? 'Jaipur, Rajasthan, India', color: AppThemeColors.textPrimaryColor),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Danger actions
            CommonCardWidget(
              padding: 0,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 14),
                    leading: Icon(Icons.logout, color: AppThemeColors.errorColor),
                    title: AppTextWidget.medium('Logout', color: AppThemeColors.textPrimaryColor),
                    onTap: () {
                      if (authRegistered) {
                        auth!.logout();
                      } else {
                        Get.offAllNamed('/login');
                      }
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(dynamic user) {
    try {
      // If you have a network avatar, use NetworkImage. If not, use local file (demo).
      if (user != null && user.profileImageUrl != null && user.profileImageUrl.toString().isNotEmpty) {
        return Image.network(user.profileImageUrl.toString(), fit: BoxFit.cover);
      }

      // fallback to local demo image shipped with container (developer preview)
      final file = File(_demoAvatarPath);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }

      // final fallback - initials
      return Container(
        color: AppThemeColors.primaryLightColor,
        child: Center(child: Text('M', style: TextStyle(fontSize: 28, color: AppThemeColors.primaryColor))),
      );
    } catch (_) {
      return Container(
        color: AppThemeColors.primaryLightColor,
        child: Center(child: Text('M', style: TextStyle(fontSize: 28, color: AppThemeColors.primaryColor))),
      );
    }
  }
}
