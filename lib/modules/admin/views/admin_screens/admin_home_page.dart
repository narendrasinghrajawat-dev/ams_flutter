
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_date_filter.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_date_picker.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_header.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_quick_tabs.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_recent_activity.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/home/admin_stats_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/admin_home_controller.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  AdminHomeController get c => Get.find<AdminHomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: c.refreshHome,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // AdminHeader(),
                // SizedBox(height: 12),

                /// 🔥 DATE PICKER (NEW)
                AdminDatePicker(),

                SizedBox(height: 12),
                AdminStatsGrid(),
                SizedBox(height: 16),
                AdminRecentActivity(),
              ],
            )

          ),
        ),
      ),
    );
  }
}
