
import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../controller/admin_home_controller.dart';

class AdminDatePicker extends StatelessWidget {
  const AdminDatePicker({super.key});

  AdminHomeController get c => Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔥 HEADER WITH CALENDAR BUTTON (REACTIVE)
        Obx(() {
          final date = c.selectedDate.value;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextWidget.medium("Select Date"),
                  AppTextWidget.small(
                    AppHelper.formatDateString(date.toString()),
                    color: AppThemeColors.textSecondaryColor,
                  ),
                ],
              ),
              AppIconButtonWidget.large(
                icon: AppConstIcons.dateIcon,
                onPressed: () => _openCalendar(context),
              ),
            ],
          );
        }),
      ],
    );
  }

  /// 🔥 CALENDAR PICKER
  Future<void> _openCalendar(BuildContext context) async {
    final selected = c.selectedDate.value;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final now = DateTime.now();

    final fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );

    c.changeDate(fullDateTime);
  }
}

