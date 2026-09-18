import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/controller/admin_profile_controller.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/profile/responsive_info_grid.dart';
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
  final AdminProfileController _adminProfileController = Get.put(AdminProfileController());

  @override
  Widget build(BuildContext context) {
    final authRegistered = Get.isRegistered<AuthController>();
    final auth = authRegistered ? Get.find<AuthController>() : null;
    final user = AppHelper.getProfileUser();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          // Avatar Banner
          Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeColors.primaryColor, width: 2.5),
              ),
              child: CircleAvatar(
                radius: 46,
                backgroundColor: AppThemeColors.primaryColor.withOpacity(0.12),
                child: Text(
                  (user.firstName.isNotEmpty)
                      ? user.firstName[0].toUpperCase()
                      : "A",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.primaryColor,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textPrimaryColor,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            user.email,
            style: TextStyle(
              fontSize: 13,
              color: AppThemeColors.textSecondaryColor,
            ),
          ),

          const SizedBox(height: 20),

          // Basic Information Section
          CommonCardWidget(
            padding: 16,
            borderRadius: 16,
            child: ResponsiveInfoGrid(
              children: [
                _InfoRow(
                  icon: Icons.person_outline_rounded,
                  iconColor: AppThemeColors.primaryColor,
                  label: 'Name',
                  value: "${user.firstName} ${user.middleName ?? ''} ${user.lastName}".trim(),
                ),
                _InfoRow(
                  icon: Icons.email_outlined,
                  iconColor: AppThemeColors.secondaryColor,
                  label: 'Email',
                  value: user.email.isNotEmpty ? user.email : 'N/A',
                ),
                _InfoRow(
                  icon: Icons.phone_outlined,
                  iconColor: AppThemeColors.successColor,
                  label: 'Phone',
                  value: user.phoneNo != null && user.phoneNo!.isNotEmpty ? user.phoneNo! : 'N/A',
                ),
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  iconColor: AppThemeColors.warningColor,
                  label: 'Address',
                  value: user.address != null && user.address!.isNotEmpty ? user.address! : "N/A",
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Settings Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionHeader(title: 'Settings'),
              const SizedBox(height: 10),
              _SettingsTile(
                icon: Icons.description_outlined,
                iconColor: AppThemeColors.primaryColor,
                title: 'Terms & Conditions',
                onTap: () => Get.toNamed('/terms'),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.privacy_tip_outlined,
                iconColor: AppThemeColors.secondaryColor,
                title: 'Privacy Policy',
                onTap: () => Get.toNamed('/privacy'),
              ),
              const SizedBox(height: 8),
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconColor: AppThemeColors.warningColor,
                title: 'Notifications',
                onTap: () => Get.toNamed('/notifications'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Change Password Button
          _ForgotPasswordButton(
            onTap: () => _showChangePasswordDialog(context, _adminProfileController),
          ),

          const SizedBox(height: 10),

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

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Future<void> _showChangePasswordDialog(BuildContext context, AdminProfileController ctrl) async {
    final TextEditingController newPassCtrl = TextEditingController();
    final TextEditingController confirmCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppThemeColors.popupBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: AppTextWidget.medium('Change Password', color: AppThemeColors.textPrimaryColor),
        content: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPassCtrl,
                obscureText: true,
                style: TextStyle(color: AppThemeColors.textPrimaryColor),
                decoration: const InputDecoration(labelText: 'New Password'),
                validator: (v) {
                  if (v == null || v.trim().length < 6) return 'Minimum 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmCtrl,
                obscureText: true,
                style: TextStyle(color: AppThemeColors.textPrimaryColor),
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (v) {
                  final confirm = v?.trim() ?? '';
                  final password = newPassCtrl.text.trim();

                  if (confirm != password && confirm.isNotEmpty && password.isNotEmpty) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: AppTextWidget.small('Cancel', color: AppThemeColors.textSecondaryColor),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemeColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                final password = newPassCtrl.text.trim();
                Get.back();
                await ctrl.changePassword(password);
              }
            },
            child: AppTextWidget.small('Change', color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: AppTextWidget.medium(
        title,
        color: AppThemeColors.textPrimaryColor,
      ),
    );
  }
}

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
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppThemeColors.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppThemeColors.textPrimaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      borderRadius: 14,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppThemeColors.textPrimaryColor,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: AppThemeColors.textSecondaryColor,
          size: 22,
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  final VoidCallback onTap;
  const _LogoutButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      borderRadius: 14,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppThemeColors.errorColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.errorColor,
                  ),
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
      borderRadius: 14,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_reset_rounded,
                  color: AppThemeColors.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Change Password',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}