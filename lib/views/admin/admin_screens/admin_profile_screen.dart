// lib/views/admin/admin_profile_screen.dart
import 'dart:io';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  final AuthController _auth = Get.find();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstNameC;
  late final TextEditingController _lastNameC;
  late final TextEditingController _emailC;
  late final TextEditingController _phoneC;
  late final TextEditingController _deptC;
  final RxBool _editMode = false.obs;
  final RxBool _saving = false.obs;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser.value;
    _firstNameC = TextEditingController(text: user?.firstName ?? '');
    _lastNameC = TextEditingController(text: user?.lastName ?? '');
    _emailC = TextEditingController(text: user?.email ?? '');
    _phoneC = TextEditingController(text: user?.phoneNo ?? '');
    _deptC = TextEditingController(text: user?.departmentId ?? '');
  }

  @override
  void dispose() {
    _firstNameC.dispose();
    _lastNameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    _deptC.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    Get.snackbar(
      'Info',
      'Image picker not implemented',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppThemeColors.primaryColor.withOpacity(0.1),
      colorText: AppThemeColors.textPrimaryColor,
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    _saving.value = true;
    await Future.delayed(const Duration(seconds: 2));

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green.withOpacity(0.1),
      colorText: Colors.green[700],
      icon: Icon(Icons.check_circle, color: Colors.green[700]),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );

    _saving.value = false;
    _editMode.value = false;
  }

  void _cancelEdit() {
    final user = _auth.currentUser.value;
    _firstNameC.text = user?.firstName ?? '';
    _lastNameC.text = user?.lastName ?? '';
    _emailC.text = user?.email ?? '';
    _phoneC.text = user?.phoneNo ?? '';
    _deptC.text = user?.departmentId ?? '';
    _editMode.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child:  CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(

          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildStatisticsRow(),
              const SizedBox(height: 24),
             Column(
                  children: [
                    _buildPersonalInfoCard(),
                    const SizedBox(height: 16),
                    _buildAccountSettingsCard(),
                    const SizedBox(height: 24),
                  ],
              ),
            ],
          ),
        ),
      ],
    )
    );
  }

  Widget _buildSliverAppBar() {
    final user = _auth.currentUser.value;

    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppThemeColors.containerBackgroundColor,
                AppThemeColors.primaryLightColor,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Image with Edit Button
                Stack(
                  children: [
                    Hero(
                      tag: 'profile_image',
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: _pickedImage == null
                              ? Text(
                            (user?.firstName?.isNotEmpty == true
                                ? user!.firstName![0]
                                : 'A')
                                .toUpperCase(),
                            style: TextStyle(
                              fontSize: 48,
                              color: AppThemeColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : ClipOval(
                            child: Image.file(
                              _pickedImage!,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      if (!_editMode.value) return const SizedBox.shrink();
                      return Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              color: AppThemeColors.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                // Name
                Text(
                  '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Email
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user?.email ?? '',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Role Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        user?.role ?? 'Admin',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        Obx(() => Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: _editMode.value
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {
              if (_editMode.value) {
                _cancelEdit();
              } else {
                _editMode.toggle();
              }
            },
            icon: Icon(
              _editMode.value ? Icons.close_rounded : Icons.edit_rounded,
              color: Colors.white,
              size: 22,
            ),
            tooltip: _editMode.value ? 'Cancel' : 'Edit Profile',
          ),
        )),
      ],
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.calendar_today_rounded,
              title: 'Attendance',
              value: '98.5%',
              color: AppThemeColors.successColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.access_time_rounded,
              title: 'Hours',
              value: '185',
              color: AppThemeColors.primaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: Icons.event_available_rounded,
              title: 'Leaves',
              value: '12',
              color: AppThemeColors.warningColor,
            ),
          ),
        ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return CommonCardWidget(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppThemeColors.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppThemeColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return CommonContainerWidget(child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppThemeColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: AppThemeColors.primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppThemeColors.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildModernTextField(
                    controller: _firstNameC,
                    label: 'First Name',
                    icon: Icons.person_outline,
                    enabled: _editMode.value,
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernTextField(
                    controller: _lastNameC,
                    label: 'Last Name',
                    icon: Icons.person_outline,
                    enabled: _editMode.value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _emailC,
              label: 'Email Address',
              icon: Icons.email_outlined,
              enabled: _editMode.value,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                if (!GetUtils.isEmail(v.trim())) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _phoneC,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
              enabled: _editMode.value,
              keyboardType: TextInputType.phone,
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildModernTextField(
              controller: _deptC,
              label: 'Department',
              icon: Icons.business_outlined,
              enabled: _editMode.value,
            ),
            Obx(() {
              if (!_editMode.value) return const SizedBox.shrink();
              return Column(
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _saving.value ? null : _cancelEdit,
                          icon: const Icon(Icons.close_rounded, size: 20),
                          label: const Text('Cancel'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(
                              color: AppThemeColors.borderColor,
                            ),
                            foregroundColor: AppThemeColors.textPrimaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: _saving.value ? null : _saveProfile,
                          icon: _saving.value
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                              AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                              : const Icon(Icons.check_rounded, size: 20),
                          label: Text(_saving.value ? 'Saving...' : 'Save Changes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemeColors.primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingsCard() {
    return CommonContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppThemeColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.settings_rounded,
                  color: AppThemeColors.primaryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppThemeColors.textPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildActionTile(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            subtitle: 'Update your password',
            color: AppThemeColors.primaryColor,
            onTap: () {
              Get.toNamed('/changePassword');
            },
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Manage notification preferences',
            color: AppThemeColors.warningColor,
            onTap: () {
              Get.snackbar('Info', 'Navigate to Notification Settings');
            },
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            subtitle: 'Get help with your account',
            color: Colors.blue,
            onTap: () {
              Get.snackbar('Info', 'Navigate to Help & Support');
            },
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.logout_rounded,
            title: 'Logout',
            subtitle: 'Sign out of your account',
            color: AppThemeColors.errorColor,
            onTap: () {
              Get.defaultDialog(
                title: 'Logout',
                titleStyle: TextStyle(
                  color: AppThemeColors.textPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
                middleText: 'Are you sure you want to logout?',
                middleTextStyle: TextStyle(
                  color: AppThemeColors.textSecondaryColor,
                ),
                backgroundColor: AppThemeColors.cardBackgroundColor,
                radius: 16,
                textCancel: 'Cancel',
                textConfirm: 'Logout',
                confirmTextColor: Colors.white,
                cancelTextColor: AppThemeColors.textPrimaryColor,
                buttonColor: AppThemeColors.errorColor,
                onConfirm: () {
                  Get.back();
                  _auth.logout();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppThemeColors.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppThemeColors.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppThemeColors.textSecondaryColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Obx(() => TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: AppThemeColors.textPrimaryColor,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: _editMode.value
              ? AppThemeColors.textSecondaryColor
              : AppThemeColors.textSecondaryColor.withOpacity(0.6),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: _editMode.value
              ? AppThemeColors.primaryColor
              : AppThemeColors.textSecondaryColor.withOpacity(0.5),
          size: 20,
        ),
        filled: true,
        fillColor: _editMode.value
            ? AppThemeColors.containerBackgroundColor
            : AppThemeColors.containerBackgroundColor.withOpacity(0.3),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemeColors.borderColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemeColors.borderColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemeColors.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemeColors.errorColor,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppThemeColors.errorColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    ));
  }
}