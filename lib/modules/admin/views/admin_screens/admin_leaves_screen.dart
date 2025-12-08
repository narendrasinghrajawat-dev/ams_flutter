import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../widgets/card/common_card.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../models/admin_action.dart';
import '../../controller/admin_leaves_controller.dart';
import 'admin_widgets/admin_leaves_screen_widgets.dart';

class AdminLeavesScreen extends StatelessWidget {
  const AdminLeavesScreen({Key? key}) : super(key: key);

  AdminLeavesController get _admin => Get.find<AdminLeavesController>();

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextWidget.medium(
              'Leave Requests'.tr,
              color: AppThemeColors.textPrimaryColor,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {

                final list = _admin.filteredLeaveRequestsList;

                if (list.isEmpty) {
                  return Center(
                    child: AppTextWidget.small(
                      'No leave requests'.tr,
                      color: AppThemeColors.muted,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (_, idx) {
                    final leaveRequest = list[idx];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: LeaveRequestListItem(
                        leaveRequest: leaveRequest,
                        // on approve
                        onApprove: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus: AppStrings.approvedStatusKey,
                            approveByKey: AppHelper.getProfileUser().key!,
                          );
                          _admin.approveLeave(payload);
                        },
                        // on reject
                        onReject: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus: AppStrings.rejectedStatusKey,
                            approveByKey: AppHelper.getProfileUser().key!,
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
