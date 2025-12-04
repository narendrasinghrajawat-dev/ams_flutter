import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/card/common_card.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';

class AdminLeavesScreen extends StatelessWidget {
  AdminLeavesScreen({Key? key}) : super(key: key);
  final AdminController _admin = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(child:  Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AppTextWidget.medium('Leave Requests'.tr, color: AppThemeColors.textPrimaryColor),
            const SizedBox(height: 8),
            Obx(() {
              final list = _admin.leaveRequests;
              if (list.isEmpty) return Center(child: AppTextWidget.small('No leave requests'.tr, color: AppThemeColors.muted));
              return Expanded(
                child: ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => Divider(color: AppThemeColors.dividerColor),
                  itemBuilder: (_, idx) {
                    final l = list[idx];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: AppTextWidget.small(l.userName, color: AppThemeColors.textPrimaryColor),
                      subtitle: AppTextWidget.verySmall('${l.from} → ${l.to}', color: AppThemeColors.muted),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (l.status == 'pending') ...[
                            IconButton(icon: Icon(Icons.check_circle, color: AppThemeColors.successColor), onPressed: () => _admin.approveLeave(l.id)),
                            IconButton(icon: Icon(Icons.cancel, color: AppThemeColors.errorColor), onPressed: () => _admin.rejectLeave(l.id)),
                          ] else
                            AppTextWidget.small(l.status.capitalizeFirst ?? l.status, color: l.status == 'approved' ? AppThemeColors.successColor : AppThemeColors.warningColor),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ]),
        ),
    );
  }
}
