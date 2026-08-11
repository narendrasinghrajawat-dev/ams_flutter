import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/admin_home_controller.dart';
import 'stat_card_widget.dart';

class AdminStatsGrid extends StatelessWidget {
  const AdminStatsGrid({super.key});

  AdminHomeController get c => Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 4 : 2,
          childAspectRatio:  kIsWeb ? 5 : 2.6,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        children: [
          StatCardWidget(
            "Total Employees",
            c.totalEmployees.toString(),
            Icons.people_alt_rounded,
            AppThemeColors.primaryColor,
          ),
          StatCardWidget(
            "Present",
            c.presentToday.toString(),
            Icons.check_circle_rounded,
            AppThemeColors.successColor,
          ),
          StatCardWidget(
            "On Leave",
            c.onLeaveToday.toString(),
            Icons.beach_access_rounded,
            AppThemeColors.warningColor,
          ),
          StatCardWidget(
            "Late Arrivals",
            c.lateArrivalsToday.toString(),
            Icons.schedule_rounded,
            AppThemeColors.errorColor,
          ),
        ],
      );
    });
  }
}
