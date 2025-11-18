import 'package:attedance_management_system/views/admin/user_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/admin_controller.dart';
import '../../controller/auth_controller.dart';
import '../../core/constants/app_theme_colors.dart';
import '../../widgets/app_text_type.dart';

class AdminDashboard extends StatelessWidget {
  AdminDashboard({Key? key}) : super(key: key);

  final AuthController _auth = Get.find<AuthController>();
  // create or find existing AdminController
  final AdminController _admin = Get.put(AdminController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppThemeColors.scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppThemeColors.appBarColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings_outlined, color: AppThemeColors.primaryColor),
              const SizedBox(width: 10),
              AppTextWidget.large('Admin Panel', color: AppThemeColors.textPrimaryColor),
            ],
          ),
          elevation: 1,
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAddUser(context),
          backgroundColor: AppThemeColors.primaryColor,
          icon: Icon(Icons.person_add, color: Colors.white),
          label: AppTextWidget.medium('Add User', color: Colors.white),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // STAT ROW
                    Obx(() => Row(
                      children: [
                        // Total users card
                        Expanded(
                          child: _StatCard(
                            title: 'Total Users'.tr,
                            value: '${_admin.users.length}',
                            icon: Icons.group,
                            color: AppThemeColors.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Pending leaves card
                        Expanded(
                          child: _StatCard(
                            title: 'Pending Leaves'.tr,
                            value: '${_admin.leaveRequests.where((l) => l.status == 'pending').length}',
                            icon: Icons.beach_access,
                            color: AppThemeColors.warningColor, // Use warning color
                          ),
                        ),
                      ],
                    )),
                    const SizedBox(height: 18),

                    // SEARCH FIELD
                    TextField(
                      onChanged: (v) => _admin.search.value = v,
                      decoration: InputDecoration(
                        hintText: 'Search users by name or email'.tr,
                        prefixIcon: Icon(Icons.search, color: AppThemeColors.iconColor),
                        filled: true,
                        fillColor: AppThemeColors.cardBackgroundColor,
                        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppThemeColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: AppThemeColors.primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10), // Increased spacing

                    // USERS CARD
                    Card(
                      color: AppThemeColors.cardBackgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppTextWidget.medium('Users'.tr, color: AppThemeColors.textPrimaryColor),
                                const Spacer(),
                                // reactive count
                                Obx(() => AppTextWidget.small('Showing ${_admin.filteredUsers.length}')),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // FIX: ListView needs shrinkWrap: true when inside SingleChildScrollView
                            Obx(() {
                              final list = _admin.filteredUsers;
                              if (list.isEmpty) {
                                return Center(child: AppTextWidget.small('No users found'.tr, color: AppThemeColors.muted));
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(), // Important when using SingleChildScrollView
                                shrinkWrap: true,
                                itemCount: list.length,
                                separatorBuilder: (_, __) => Divider(color: AppThemeColors.dividerColor),
                                itemBuilder: (_, idx) {
                                  final u = list[idx];
                                  // FIX: Removed the redundant and crashing 'Expanded' here.
                                  return _UserTile(user: u);
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ), 
                    const SizedBox(height: 18),

                    // LEAVE REQUESTS CARD
                    Card(
                      color: AppThemeColors.cardBackgroundColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextWidget.medium('Leave Requests'.tr, color: AppThemeColors.textPrimaryColor),
                            Obx(() {
                              final list = _admin.leaveRequests;
                              if (list.isEmpty) {
                                return Center(child: AppTextWidget.small('No leave requests'.tr, color: AppThemeColors.muted));
                              }
                              return ListView.separated(
                                physics: const NeverScrollableScrollPhysics(), // Important when using SingleChildScrollView
                                shrinkWrap: true,
                                itemCount: list.length,
                                separatorBuilder: (_, __) => Divider(color: AppThemeColors.dividerColor, height: 1,),
                                itemBuilder: (_, idx) {
                                  final l = list[idx];
                                  return ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: AppTextWidget.small(l.userName, color: AppThemeColors.textPrimaryColor),
                                    subtitle: AppTextWidget.verySmall('${l.from.toShortDate()} → ${l.to.toShortDate()}', color: AppThemeColors.muted),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (l.status == 'pending') ...[
                                          IconButton(
                                            icon: Icon(Icons.check_circle, color: AppThemeColors.successColor),
                                            onPressed: () => _admin.approveLeave(l.id),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.cancel, color: AppThemeColors.errorColor),
                                            onPressed: () => _admin.rejectLeave(l.id),
                                          ),
                                        ] else
                                          AppTextWidget.small(
                                            l.status.capitalizeFirst ?? l.status,
                                            // FIX: Use defined status colors
                                            color: l.status == 'approved' ? AppThemeColors.successColor : AppThemeColors.errorColor,
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    )
                  ]
              ),
            ),


        )
    );
  }

  void _openAddUser(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => UserForm(
        onSaved: (name, email, role) {
          _admin.addUser(name: name, email: email, role: role);
          Get.back(); // close sheet
          Get.snackbar('Success', 'User added', snackPosition: SnackPosition.BOTTOM);
        },
      ),
    );
  }
}

/// small stat card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppThemeColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.12),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(title, color: AppThemeColors.textSecondaryColor),
                const SizedBox(height: 6),
                AppTextWidget.large(value, color: AppThemeColors.textPrimaryColor),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// user tile
class _UserTile extends StatelessWidget {
  final dynamic user;

  const _UserTile({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? '';
    final email = user.email ?? '';
    final role = user.role ?? 'user';
    final dept = user.deptId ?? '-';
    final joined = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppThemeColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemeColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          // Avatar with gradient border
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppThemeColors.primaryLightColor,
                  AppThemeColors.primaryColor,
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: AppThemeColors.scaffoldBackgroundColor,
              child: Text(
                (name.isNotEmpty ? name[0] : 'U').toUpperCase(),
                style: TextStyle(
                  color: AppThemeColors.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // User main info
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AppTextWidget.medium(name, color: AppThemeColors.textPrimaryColor),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppThemeColors.primaryLightColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppThemeColors.primaryColor),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.badge_outlined, size: 14, color: AppThemeColors.primaryColor),
                                    const SizedBox(width: 4),
                                    AppTextWidget.small(role, color: AppThemeColors.primaryColor),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.email_outlined, size: 16, color: AppThemeColors.iconColor),
                            const SizedBox(width: 4),
                            Expanded(
                              child: AppTextWidget.small(email, color: AppThemeColors.muted),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        // Role + Department row
                        Row(
                          children: [
                            // Role badge chip

                            Row(
                              children: [
                                Icon(Icons.calendar_month_outlined, size: 15, color: AppThemeColors.iconColor),
                                const SizedBox(width: 4),
                                AppTextWidget.verySmall(
                                  "Joined: ${joined.day}/${joined.month}/${joined.year}",
                                  color: AppThemeColors.muted,
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),

                            // Department
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.business_outlined, size: 16, color: AppThemeColors.iconColor),
                                const SizedBox(width: 4),
                                AppTextWidget.verySmall("Dept: $dept", color: AppThemeColors.textSecondaryColor),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )

                  ],
                ),
                ),
                PopupMenuButton<String>(
                  onSelected: (v) {
                    if (v == 'edit') {
                      Get.snackbar('Edit User', 'Editing ${user.name}', snackPosition: SnackPosition.BOTTOM);
                    } else if (v == 'delete') {
                      Get.snackbar('Delete User', 'Deleting ${user.name}', snackPosition: SnackPosition.BOTTOM);
                    }
                  },
                  icon: Icon(Icons.more_vert, color: AppThemeColors.iconColor),
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: AppTextWidget.small("Edit", color: AppThemeColors.textPrimaryColor)),
                    PopupMenuItem(value: 'delete', child: AppTextWidget.small("Delete", color: AppThemeColors.textPrimaryColor)),
                  ],
                ),

              ],
            )
          ),

          // Menu button
        ],
      ),
    );
  }
}

/// small date helper (extension)
extension _DateShort on DateTime {
  String toShortDate() {
    return "${this.day.toString().padLeft(2, '0')}/${this.month.toString().padLeft(2, '0')}/${this.year}";
  }
}
