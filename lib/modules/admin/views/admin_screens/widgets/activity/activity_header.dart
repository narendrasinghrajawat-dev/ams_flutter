
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../controller/admin_activity_controller.dart';
class ActivityHeader extends StatelessWidget {
  final AdminActivityController controller;

  const ActivityHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final date = controller.selectedDate.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextWidget.medium("Admin Activity"),
              AppTextWidget.small(
                DateFormat('dd MMM yyyy').format(date),
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
    final selected = controller.selectedDate.value;

    // Pick only DATE
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selected,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    final now = DateTime.now();

    // 🔥 Merge picked DATE + CURRENT TIME
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

    print('picked datetime with current time: $fullDateTime');

    // Update controller
    controller.changeDate(fullDateTime);
  }

}
