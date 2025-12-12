import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/empty_state.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/leave_balance_card.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/leave_card.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/segmented_tabs.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/summary_card.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/common/common_dialong_box.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icon_button.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/const_strings.dart';
import '../../../../data/utils/app_helper.dart';
import '../../controller/user_leaves_controller.dart';
import '../../../models/apply_leave_request.dart';
import 'forms/user_apply_leaves_form.dart';

class UserLeavesScreen extends StatefulWidget {
  const UserLeavesScreen({Key? key}) : super(key: key);

  @override
  State<UserLeavesScreen> createState() => _UserLeavesScreenState();
}

class _UserLeavesScreenState extends State<UserLeavesScreen> {
  /// 0 = Approved, 1 = Pending, 2 = Rejected, 3 = Cancelled
  int _activeTab = 0;
  final UserLeavesController _controller = Get.find<UserLeavesController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 12),
            child: Column(
              children: [
                _buildBalancesList(),
                const SizedBox(height: 5),
                Expanded(
                  child: Obx(() => _buildSummaryAndList()),
                ),
              ],
            ),
          ),
        ),
        // Floating Action Button
        Positioned(
          bottom: 20,
          right: 20,
          child: GestureDetector(
            onTap: () => showCommonDialog(
              context: context,
              child:  UserApplyLeavesForm(),
            ),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppThemeColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: AppIconWidget.veryLarge(AppConstIcons.addIcon, color: AppThemeColors.whiteColor,)
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildBalancesList() {
    return Obx(() {
      final list = _controller.filteredLeaveBalanceList; // should be RxList in controller

      if (list.isEmpty) {
        return const EmptyStateWidget(message: 'No leave balances available');
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (ctx, idx) {
          final balance = list[idx];
          return LeaveBalanceCard(balance: balance);
        },
      );
    });
  }

  Widget _buildSummaryAndList() {
    final List<ApplyLeaveRequest> all = _controller.filteredAppliedLeavesList;

    final approved = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == AppStrings.approvedLeavesStatusKey).toList();
    final pending = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == AppStrings.pendingLeavesStatusKey).toList();
    final rejected = all.where((e) => (e.leaveStatus ?? '').toLowerCase() ==AppStrings.rejectedLeavesStatusKey).toList();
    final cancelled = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == AppStrings.cancelledLeavesStatusKey).toList();

    final activeList = _getActiveList(approved, pending, rejected, cancelled);

    return Expanded(
      child: Column(
        children: [
          CommonCardWidget(
              child: Column(
                children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: AppTextWidget.small("Total"),),
                AppTextWidget.medium(all.length.toString(), color: AppHelper.getLeavesStatusColor(""),),
              ],
            ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AppTextWidget.small("Approved"),),
                      AppTextWidget.medium(approved.length.toString(), color: AppHelper.getLeavesStatusColor(AppStrings.approvedLeavesStatusKey),),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AppTextWidget.small("Pending"),),
                      AppTextWidget.medium(pending.length.toString(), color: AppHelper.getLeavesStatusColor(AppStrings.pendingLeavesStatusKey),),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AppTextWidget.small("Rejected"),),
                       AppTextWidget.medium(rejected.length.toString(), color: AppHelper.getLeavesStatusColor(AppStrings.rejectedLeavesStatusKey),),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: AppTextWidget.small("Cancelled"),),
                      AppTextWidget.medium(cancelled.length.toString(), color: AppHelper.getLeavesStatusColor(AppStrings.cancelledLeavesStatusKey),),
                    ],
                  ),


          ],
              )
          ),

          const SizedBox(height: 10),

          SegmentedTabs(
            labels: const ['Approved', 'Pending', 'Rejected', 'Cancelled'],
            selectedIndex: _activeTab,
            onTap: (i) => setState(() => _activeTab = i),
          ),

          const SizedBox(height: 12),

          // List of leaves
          Expanded(
            child: activeList.isEmpty
                ? const EmptyStateWidget(message: 'No leaves found')
                : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: activeList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, idx) {
                final leave = activeList[idx];
                return LeaveCard(leave: leave);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<ApplyLeaveRequest> _getActiveList(
      List<ApplyLeaveRequest> approved,
      List<ApplyLeaveRequest> pending,
      List<ApplyLeaveRequest> rejected,
      List<ApplyLeaveRequest> cancelled,
      ) {
    switch (_activeTab) {
      case 0:
        return approved;
      case 1:
        return pending;
      case 2:
        return rejected;
      case 3:
        return cancelled;
      default:
        return approved;
    }
  }
}