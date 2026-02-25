import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../../models/user.dart';
import '../employee/user_action_menu.dart';
import 'employee_info_item.dart';

class EmployeeTile extends StatelessWidget {
  final User user;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onChangePassword;

  const EmployeeTile({
    super.key,
    required this.user,
    required this.onEdit,
    required this.onDelete,
    required this.onChangePassword,
  });

  @override
  Widget build(BuildContext context) {

    return CommonCardWidget(
      padding: 14,
      child: Column(
        children: [
          /// 🔹 TOP ROW (Avatar + Name + Menu)
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor:
                AppThemeColors.primaryLightColor.withOpacity(.3),
                child: AppTextWidget.medium(
                  user.firstName.isNotEmpty ? AppHelper.formatUserName(user)[0] : 'U',
                  color: AppThemeColors.primaryColor,
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
                    const SizedBox(height: 2),
                    AppTextWidget.small(
                      user.email,
                      color: AppThemeColors.muted,
                    ),
                  ],
                ),
              ),

              UserActionMenu(
                onEdit: onEdit,
                onChangePassword: onChangePassword,
                onDelete: onDelete,
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),

          /// 🔹 META INFO ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InfoItem(
                icon: Icons.cake_outlined,
                label: 'DOB',
                value: AppHelper.formatDateString(user.dob),
              ),
              InfoItem(
                icon: Icons.male,
                label: 'Gender',
                value: AppHelper.getGenderName(user.genderId) ?? "",
              ),
              InfoItem(
                icon: Icons.calendar_month_outlined,
                label: 'Joined',
                value: AppHelper.formatDateString(user.joinedDate),
              ),
              InfoItem(
                icon: Icons.perm_identity_outlined,
                label: 'EMP ID',
                value: user.employeeId ?? "",
              ),

            ],
          ),
        ],
      ),
    );
  }
}
