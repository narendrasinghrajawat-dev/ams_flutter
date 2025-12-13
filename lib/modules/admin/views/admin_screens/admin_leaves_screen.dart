import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/modules/admin/views/admin_screens/widgets/admin_leaves_screen_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../models/admin_action.dart';
import '../../controller/admin_leaves_controller.dart';

class AdminLeavesScreen extends StatelessWidget {
  const AdminLeavesScreen({Key? key}) : super(key: key);

  AdminLeavesController get _admin => Get.find<AdminLeavesController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

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
                    return LeaveRequestListItem(
                        leaveRequest: leaveRequest,
                        // on approve
                        onApprove: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus: AppStrings.approvedLeavesStatusKey,
                            approveByKey: AppHelper.getProfileUser().key!,
                          );
                          _admin.approveLeave(payload);
                        },
                        // on reject
                        onReject: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus: AppStrings.rejectedLeavesStatusKey,
                            approveByKey: AppHelper.getProfileUser().key!,
                          );
                          _admin.rejectLeave(payload);
                        },
                    ).marginOnly(bottom: 10);
                  },
                );
              }),
            ),
          ],
        ),
    );
  }
}
