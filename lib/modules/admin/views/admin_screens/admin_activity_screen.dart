import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/activity/activity_header.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/activity/activity_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/card/common_card.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../models/attendance_activity.dart';
import '../../../user/views/user_screens/widgets/home/activity_tile.dart';
import '../../controller/admin_activity_controller.dart';

class AdminActivityScreen extends StatelessWidget {
  const AdminActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AdminActivityController>();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER + DATE PICKER
          ActivityHeader(controller: c),

          const SizedBox(height: 12),

          /// 🔹 ACTIVITY LIST (Responsive)
          Expanded(
            child: Obx(() {
              final list = c.activities;

              if (list.isEmpty) {
                return Center(
                  child: AppTextWidget.small(
                    "No Activity found for selected date",
                    color: AppThemeColors.textSecondaryColor,
                  ),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  /// 🧠 Responsive columns

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kIsWeb ? 2 : 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: kIsWeb ? 9.7 : 4.5,
                    ),
                    itemBuilder: (_, index) {
                      return AdminActivityTile(
                        activity: list[index],
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
