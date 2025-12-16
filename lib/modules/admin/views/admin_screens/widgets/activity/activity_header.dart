
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../controller/admin_activity_controller.dart';



class ActivityHeader extends StatelessWidget {
  final AdminActivityController controller;

  const ActivityHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final String dateString = controller.selectedDate.value;
      final DateTime date = DateTime.parse(dateString);

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.medium("Admin Activity"),
              AppTextWidget.small(
                AppHelper.formatDateString(dateString),
                color: AppThemeColors.textSecondaryColor,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () => _openCalendar(context),
          ),
        ],
      );
    });
  }

  Future<void> _openCalendar(BuildContext context) async {
    final String selectedString = controller.selectedDate.value;
    final DateTime selectedDate = DateTime.parse(selectedString);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final DateTime now = DateTime.now();

    // 🔥 Merge picked DATE + CURRENT TIME
    final DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      now.hour,
      now.minute,
      now.second,
      now.millisecond,
      now.microsecond,
    );

    // 🔁 Convert back to STRING (ISO)
    controller.changeDate(fullDateTime.toIso8601String());
  }
}
