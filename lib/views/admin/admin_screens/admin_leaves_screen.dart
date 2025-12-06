import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/admin_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../models/admin_action.dart';
import '../../../widgets/card/common_card.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';
// Import the new item widget
import 'admin_widgets/admin_leaves_screen_widgets.dart';

class AdminLeavesScreen extends StatelessWidget {
  AdminLeavesScreen({Key? key}) : super(key: key);
  final AdminController _admin = Get.find<AdminController>();

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextWidget.medium('Leave Requests'.tr, color: AppThemeColors.textPrimaryColor),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                final list = _admin.filteredLeaveRequestsList;
                if (list.isEmpty) {
                  return Center(child: AppTextWidget.small('No leave requests'.tr, color: AppThemeColors.muted));
                }
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) {
                    final leaveRequest = list[idx];
                    // Use the new dedicated list item widget
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: LeaveRequestListItem(
                        leaveRequest: leaveRequest,
                        // 🟢 ON APPROVE
                        onApprove: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!, // Leaves ID (document _key)
                            leavesStatus: AppStrings.approvedStatusKey, // Status code for Approved
                            approveByKey: AppHelper.getProfileUser().key!, // Admin's key
                          );
                          _admin.approveLeave(payload);
                        },

                        // 🔴 ON REJECT
                        onReject: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!, // Leaves ID (document _key)
                            leavesStatus: AppStrings.rejectedStatusKey, // Status code for Rejected
                            approveByKey: AppHelper.getProfileUser().key!, // Admin's key
                          );
                          _admin.rejectLeave(payload);
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
// Assuming ApplyLeaveRequest model is available in the scope
// class ApplyLeaveRequest {...}