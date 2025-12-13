import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/activity/activity_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/card/common_card.dart';
import '../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../controller/admin_activity_controller.dart';

class AdminActivityScreen extends StatelessWidget {
  const AdminActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminActivityController>(
      init: AdminActivityController(),
      builder: (c) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔹 HEADER + DATE PICKER
              ActivityHeader(controller: c),

              const SizedBox(height: 12),

              /// 🔹 ACTIVITY LIST
              Expanded(
                child: Obx(() {

                  if (c.activities.isEmpty) {
                    return Center(
                      child: AppTextWidget.small(
                        "No activity found for selected date",
                        color: AppThemeColors.textSecondaryColor,
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: c.activities.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 8),
                    itemBuilder: (_, index) {
                      final item = c.activities[index];

                      return CommonCardWidget(
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                              AppThemeColors.primaryColor
                                  .withOpacity(0.1),
                              child: Icon(
                                Icons.timeline,
                                color: AppThemeColors.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  AppTextWidget.small(
                                    item['userName'] ?? 'User',
                                  ),
                                  const SizedBox(height: 2),
                                  AppTextWidget.verySmall(
                                    item['activity'] ?? 'Activity',
                                    color: AppThemeColors
                                        .textSecondaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
