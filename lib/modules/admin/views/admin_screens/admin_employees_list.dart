import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../models/user.dart';
import '../../controller/admin_employees_controller.dart';
import '../user_form_screen.dart';

class AdminEmployeesList extends StatelessWidget {
  const AdminEmployeesList({Key? key}) : super(key: key);

  AdminEmployeesController get _admin =>
      Get.find<AdminEmployeesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Obx(() {

        final list = _admin.filteredUsers;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                AppTextWidget.medium(
                  'Employees'.tr,
                  color: AppThemeColors.textPrimaryColor,
                ),
                const Spacer(),
                AppTextWidget.small(
                  'Showing ${list.length}',
                  color: AppThemeColors.muted,
                ),
              ]),
              const SizedBox(height: 10),
              if (list.isEmpty)
                Center(
                  child: AppTextWidget.small(
                    'No users found'.tr,
                    color: AppThemeColors.muted,
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: list.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
                  itemBuilder: (_, idx) {
                    final u = list[idx];
                    return _UserTile(user: u);
                  },
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _UserTile extends StatelessWidget {
  final User user;
  _UserTile({required this.user, Key? key}) : super(key: key);

  final AdminEmployeesController _adminController =
  Get.find<AdminEmployeesController>();

  @override
  Widget build(BuildContext context) {
    final name = (user.firstName ?? '') +
        (user.lastName != null ? ' ${user.lastName}' : '');
    final email = user.email ?? '';
    final dept = user.departmentId ?? '-';
    final joined = DateTime.now();

    return CommonCardWidget(
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
            AppThemeColors.primaryLightColor.withOpacity(0.3),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(color: AppThemeColors.primaryColor),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.medium(
                  AppHelper.formatUserName(user),
                  color: AppThemeColors.textPrimaryColor,
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.email_outlined,
                      size: 14, color: AppThemeColors.iconColor),
                  const SizedBox(width: 6),
                  AppTextWidget.small(
                    email,
                    color: AppThemeColors.muted,
                  ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.business_outlined,
                      size: 14, color: AppThemeColors.iconColor),
                  const SizedBox(width: 6),
                  AppTextWidget.verySmall(
                    'Dept: $dept',
                    color: AppThemeColors.textSecondaryColor,
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.calendar_month_outlined,
                      size: 14, color: AppThemeColors.iconColor),
                  const SizedBox(width: 6),
                  AppTextWidget.verySmall(
                    'Joined: ${joined.day}/${joined.month}/${joined.year}',
                    color: AppThemeColors.muted,
                  ),
                ]),
              ],
            ),
          ),
          Column(
            children: [
              AppIconButtonWidget.medium(
                icon: AppConstIcons.editIcon,
                color: AppThemeColors.editIconColors,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => UserForm(initialData: user),
                  );
                },
              ).marginOnly(bottom: 5),
              AppIconButtonWidget.medium(
                icon: AppConstIcons.deleteIcon,
                color: AppThemeColors.deleteIconColor,
                onPressed: () {
                  if (user.key != null) {
                    _adminController.deleteUser(user.key!);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
