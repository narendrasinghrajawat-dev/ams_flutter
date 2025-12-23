import 'package:attedance_management_system/core/constants/app_icons.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/empty_state.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/leave_balance_card.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/leave_card.dart';
import 'package:attedance_management_system/modules/user/views/user_screens/widgets/leaves/segmented_tabs.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/common/common_dialong_box.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/foundation.dart';
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

  final UserLeavesController _controller =
  Get.find<UserLeavesController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                _buildBalancesList(),
                const SizedBox(height: 10),
                _buildSummaryAndList(),
              ],
            ),
          ),
        ),

        /// ➕ FAB (APP ONLY)
        if (!kIsWeb)
          Positioned(
            bottom: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => showCommonDialog(
                context: context,
                child: const UserApplyLeavesForm(),
              ),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppThemeColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: AppIconWidget.veryLarge(
                  AppConstIcons.addIcon,
                  color: AppThemeColors.whiteColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LEAVE BALANCE GRID
  // ---------------------------------------------------------------------------
  Widget _buildBalancesList() {
    return Obx(() {
      final list = _controller.filteredLeaveBalanceList;

      if (list.isEmpty) {
        return const EmptyStateWidget(
            message: 'No leave balances available');
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 2 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: kIsWeb ? 5.5 : 1.7,
        ),
        itemBuilder: (_, idx) {
          return LeaveBalanceCard(balance: list[idx]);
        },
      );
    });
  }

  // ---------------------------------------------------------------------------
  // SUMMARY + TABS + LIST
  // ---------------------------------------------------------------------------
  Widget _buildSummaryAndList() {
    return Expanded(
      child: Obx(() {
        final List<ApplyLeaveRequest> all =
            _controller.filteredAppliedLeavesList;

        final approved = all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.approvedLeavesStatusKey)
            .toList();

        final pending = all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.pendingLeavesStatusKey)
            .toList();

        final rejected = all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.rejectedLeavesStatusKey)
            .toList();

        final cancelled = all
            .where((e) =>
        (e.leaveStatus ?? '').toLowerCase() ==
            AppStrings.cancelledLeavesStatusKey)
            .toList();

        final activeList =
        _getActiveList(approved, pending, rejected, cancelled);

        return Column(
          children: [
            /// 🔹 SUMMARY CARD (Responsive)
            LayoutBuilder(
              builder: (context, constraints) {
                final bool isWeb = constraints.maxWidth >= 800;

                return CommonCardWidget(
                  child: isWeb
                      ? Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      _SummaryItem(
                        title: 'Total Applied',
                        value: all.length,
                        color:
                        AppHelper.getLeavesStatusColor(''),
                        vertical: true,
                      ),
                      _SummaryItem(
                        title: 'Approved',
                        value: approved.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .approvedLeavesStatusKey),
                        vertical: true,
                      ),
                      _SummaryItem(
                        title: 'Pending',
                        value: pending.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .pendingLeavesStatusKey),
                        vertical: true,
                      ),
                      _SummaryItem(
                        title: 'Rejected',
                        value: rejected.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .rejectedLeavesStatusKey),
                        vertical: true,
                      ),
                      _SummaryItem(
                        title: 'Cancelled',
                        value: cancelled.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .cancelledLeavesStatusKey),
                        vertical: true,
                      ),
                    ],
                  )
                      : Column(
                    children: [
                      _SummaryItem(
                        title: 'Total Applied',
                        value: all.length,
                        color:
                        AppHelper.getLeavesStatusColor(''),
                        vertical: false,
                      ),
                      _SummaryItem(
                        title: 'Approved',
                        value: approved.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .approvedLeavesStatusKey),
                        vertical: false,
                      ),
                      _SummaryItem(
                        title: 'Pending',
                        value: pending.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .pendingLeavesStatusKey),
                        vertical: false,
                      ),
                      _SummaryItem(
                        title: 'Rejected',
                        value: rejected.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .rejectedLeavesStatusKey),
                        vertical: false,
                      ),
                      _SummaryItem(
                        title: 'Cancelled',
                        value: cancelled.length,
                        color: AppHelper.getLeavesStatusColor(
                            AppStrings
                                .cancelledLeavesStatusKey),
                        vertical: false,
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            /// 🔹 TABS
            SegmentedTabs(
              labels: const [
                'Approved',
                'Pending',
                'Rejected',
                'Cancelled'
              ],
              selectedIndex: _activeTab,
              onTap: (i) => setState(() => _activeTab = i),
            ),

            const SizedBox(height: 12),

            /// 🔹 LIST
            Expanded(
              child: activeList.isEmpty
                  ? const EmptyStateWidget(
                message: 'No leaves found',
              )
                  : ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: activeList.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),
                itemBuilder: (_, idx) {
                  return LeaveCard(
                    leave: activeList[idx],
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIVE LIST BASED ON TAB
  // ---------------------------------------------------------------------------
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

// -----------------------------------------------------------------------------
// SUMMARY ITEM
// -----------------------------------------------------------------------------
class _SummaryItem extends StatelessWidget {
  final String title;
  final int value;
  final Color color;
  final bool vertical;

  const _SummaryItem({
    required this.title,
    required this.value,
    required this.color,
    required this.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return vertical
        ? Column(
      children: [
        AppTextWidget.small(
          title,
          color: AppThemeColors.muted,
        ),
        const SizedBox(height: 6),
        AppTextWidget.large(
          value.toString(),
          color: color,
        ),
      ],
    )
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextWidget.small(title),
        AppTextWidget.medium(
          value.toString(),
          color: color,
        ),
      ],
    );
  }
}
