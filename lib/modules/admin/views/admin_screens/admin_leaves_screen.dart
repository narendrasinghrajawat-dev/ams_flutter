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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 STATUS FILTER
          _buildStatusFilter(_admin),

          const SizedBox(height: 12),

          /// 🔹 LEAVE LIST
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  /// 🧠 Responsive logic
                  final bool isWebTwoColumn = constraints.maxWidth >= 800;

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWebTwoColumn ? 2 : 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: isWebTwoColumn ? 5.5 : 3.8,
                    ),
                    itemBuilder: (_, idx) {
                      final leaveRequest = list[idx];

                      return LeaveRequestListItem(
                        leaveRequest: leaveRequest,

                        /// APPROVE
                        onApprove: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus:
                            AppStrings.approvedLeavesStatusKey,
                            approveByKey:
                            AppHelper.getProfileUser().key!,
                          );
                          _admin.approveLeave(payload);
                        },

                        /// REJECT
                        onReject: () {
                          final payload = AdminAction(
                            leavesId: leaveRequest.key!,
                            leavesStatus:
                            AppStrings.rejectedLeavesStatusKey,
                            approveByKey:
                            AppHelper.getProfileUser().key!,
                          );
                          _admin.rejectLeave(payload);
                        },
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


  Widget _buildStatusFilter(AdminLeavesController admin) {
    final labels = ['All', 'Approved', 'Pending', 'Rejected'];

    return Obx(() {
      return Row(
        children: List.generate(labels.length, (index) {
          final bool isSelected = admin.selectedFilter.value == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => admin.changeFilter(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppThemeColors.primaryColor.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppThemeColors.primaryColor
                        : AppThemeColors.borderColor,
                  ),
                ),
                child: Center(
                  child: AppTextWidget.small(
                    labels[index],
                    color: isSelected
                        ? AppThemeColors.primaryColor
                        : AppThemeColors.textSecondaryColor,
                  ),
                ),
              ),
            ),
          );
        }),
      );
    });
  }


}
