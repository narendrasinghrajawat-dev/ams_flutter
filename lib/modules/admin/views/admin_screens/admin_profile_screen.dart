// lib/views/user/user_profile_screen.dart
import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/controller/admin_profile_controller.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/profile/responsive_info_grid.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../widgets/card/common_card.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../auth/controller/auth_controller.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final AdminProfileController _adminProfileController = Get.put(AdminProfileController()); // or Get.find if already registered

  static const String networkImage = 'https://t4.ftcdn.net/jpg/03/26/98/51/360_F_326985142_1aaKcEjMQW6ULp6oI9MYuv8lN9f8sFmj.jpg';

  @override
  Widget build(BuildContext context) {
    final authRegistered = Get.isRegistered<AuthController>();
    final auth = authRegistered ? Get.find<AuthController>() : null;
    final user = AppHelper.getProfileUser();

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child:  SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20,),

          CircleAvatar(
            radius: 50,
            backgroundColor: AppThemeColors.primaryColor.withOpacity(0.1),
            child: Text(
              (user?.firstName != null && user!.firstName!.isNotEmpty)
                  ? user.firstName![0].toUpperCase()
                  : "U",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppThemeColors.primaryColor,
              ),
            ),
          ),


          // Basic Information Section

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            CommonCardWidget(
              child: ResponsiveInfoGrid(
                children: [
                  _InfoRow(
                    icon: Icons.person,
                    iconColor: Colors.blue.shade600,
                    label: 'Name',
                    value:
                    "${user?.firstName ?? ""} ${user?.middleName ?? ""} ${user?.lastName ?? ""}",
                  ),
                  _InfoRow(
                    icon: Icons.email_rounded,
                    iconColor: Colors.orange.shade600,
                    label: 'Email',
                    value: user?.email ?? 'michael@example.com',
                  ),
                  _InfoRow(
                    icon: Icons.phone_rounded,
                    iconColor: Colors.green.shade600,
                    label: 'Phone',
                    value: user.phoneNo ?? '+91 98765 43210',
                  ),
                  _InfoRow(
                    icon: Icons.location_on_rounded,
                    iconColor: Colors.red.shade600,
                    label: 'Address',
                    value: user.address ?? "",
                  ),

                ],
              ),
            ),
          ],
        ),

          const SizedBox(height: 20),

          // Settings Section
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(title: 'Settings'),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.description_rounded,
                  iconColor: Colors.indigo.shade400,
                  title: 'Terms & Conditions',
                  onTap: () => Get.toNamed('/terms'),
                ),
                const SizedBox(height: 10),
                _SettingsTile(
                  icon: Icons.privacy_tip_rounded,
                  iconColor: Colors.teal.shade400,
                  title: 'Privacy Policy',
                  onTap: () => Get.toNamed('/privacy'),
                ),
                const SizedBox(height: 10),
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  iconColor: Colors.amber.shade600,
                  title: 'Notifications',
                  onTap: () => Get.toNamed('/notifications'),
                ),
              ],
            ),

          const SizedBox(height: 20),


          // Logout Button
        _ForgotPasswordButton(
              onTap: () => _showChangePasswordDialog(context, _adminProfileController),
            ),

          SizedBox(height: 10,),
          // Logout Button
         _LogoutButton(
              onTap: () {
                if (authRegistered) {
                  auth!.logout();
                } else {
                  Get.offAllNamed('/login');
                }
              },
          ),

          const SizedBox(height: 30),
        ],
      ),
    )
    );
  }


  Future<void> _showChangePasswordDialog(BuildContext context, AdminProfileController ctrl) async {
    final TextEditingController newPassCtrl = TextEditingController();
    final TextEditingController confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: AppTextWidget.medium('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPassCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (v) {
                  if (v == null || v.trim().length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (v) {
                  if (v == null || v.trim() != newPassCtrl.text.trim()) return 'Passwords do not match';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: AppTextWidget.small('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                Get.back();
                await ctrl.changePassword(newPassCtrl.text.trim());
              }
            },
            child: AppTextWidget.small('Change'),
          ),
        ],
      ),
    );

    // dispose controllers
    newPassCtrl.dispose();
    confirmCtrl.dispose();
  }


}



// Section Header Widget
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: AppTextWidget.medium(
        title,
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(
                  label,
                ),
                const SizedBox(height: 4),
                AppTextWidget.medium(
                  value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


// Settings Tile Widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: AppTextWidget.medium(
          title,
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: Colors.grey.shade400,
          size: 24,
        ),
      ),
    );
  }
}

// Logout Button Widget
class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: Colors.red.shade600,
                  size: 22,
                ),
                const SizedBox(width: 10),
                AppTextWidget.large(
                  'Logout',
                  color: Colors.red.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ForgotPasswordButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.password,
                  color: Colors.orange.shade600,
                  size: 22,
                ),
                const SizedBox(width: 10),
                AppTextWidget.large(
                  'Forgot Password',
                  color: Colors.orange.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}