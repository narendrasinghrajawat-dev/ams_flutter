import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';

class AdminEmployeesList extends StatelessWidget {
  AdminEmployeesList({Key? key}) : super(key: key);
  final AdminController _admin = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
      child: Card(
        color: AppThemeColors.cardBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  AppTextWidget.medium('Employees'.tr, color: AppThemeColors.textPrimaryColor),
                  const Spacer(),
                  Obx(() => AppTextWidget.small('Showing ${_admin.filteredUsers.length}')),
                ]),
                const SizedBox(height: 10),
                Obx(() {
                  final list = _admin.filteredUsers;
                  if (list.isEmpty) return Center(child: AppTextWidget.small('No users found'.tr, color: AppThemeColors.muted));
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Divider(color: AppThemeColors.dividerColor),
                    itemBuilder: (_, idx) {
                      final u = list[idx];
                      return _UserTile(user: u);
                    },
                  );
                }),
              ],
            ),
          )
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final dynamic user;
  const _UserTile({required this.user, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = (user.firstName ?? '') + (user.lastName != null ? ' ${user.lastName}' : '');
    final email = user.email ?? '';
    final role = user.role ?? 'user';
    final dept = user.departmentId ?? '-';
    final joined = DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppThemeColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppThemeColors.borderColor),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppThemeColors.primaryLightColor.withOpacity(0.3),
            child: Text(name.isNotEmpty ? name[0].toUpperCase() : 'U', style: TextStyle(color: AppThemeColors.primaryColor)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppTextWidget.medium(name, color: AppThemeColors.textPrimaryColor),
              const SizedBox(height: 4),
              Row(
                  children:
              [
                Icon(Icons.email_outlined, size: 14, color: AppThemeColors.iconColor),
                const SizedBox(width: 6),
                AppTextWidget.small(email, color: AppThemeColors.muted),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.business_outlined, size: 14, color: AppThemeColors.iconColor),
                const SizedBox(width: 6),
                AppTextWidget.verySmall('Dept: $dept', color: AppThemeColors.textSecondaryColor),
                const SizedBox(width: 12),
                Icon(Icons.calendar_month_outlined, size: 14, color: AppThemeColors.iconColor),
                const SizedBox(width: 6),
                AppTextWidget.verySmall('Joined: ${joined.day}/${joined.month}/${joined.year}', color: AppThemeColors.muted),
              ]),
            ]),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') Get.snackbar('Edit', 'Edit ${user.firstName}');
              if (v == 'delete') Get.snackbar('Delete', 'Delete ${user.firstName}');
            },
            icon: Icon(Icons.more_vert, color: AppThemeColors.iconColor),
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: AppTextWidget.small('Edit', color: AppThemeColors.textPrimaryColor)),
              PopupMenuItem(value: 'delete', child: AppTextWidget.small('Delete', color: AppThemeColors.textPrimaryColor)),
            ],
          ),
        ],
      ),
    );
  }
}
