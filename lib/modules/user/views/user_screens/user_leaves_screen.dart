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
import '../../../common/views/ui_helpers.dart';
import '../../../models/leave_balance.dart';
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
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              children: [
                UIHelpers.responsive(
                  context: context,
                  children: [
                    _buildBalancesList(),
                    Obx(() {
                      final all = _controller.filteredAppliedLeavesList;

                      // 🔹 Status-wise count map
                      final Map<String, int> statusCount = {
                        AppStrings.approvedLeavesStatusKey: 0,
                        AppStrings.pendingLeavesStatusKey: 0,
                        AppStrings.rejectedLeavesStatusKey: 0,
                        AppStrings.cancelledLeavesStatusKey: 0,
                      };

                      for (final e in all) {
                        final status = (e.leaveStatus ?? '').toLowerCase();
                        if (statusCount.containsKey(status)) {
                          statusCount[status] = statusCount[status]! + 1;
                        }
                      }

                      // 🔹 UI config list
                      final items = [
                        ('Total Applied', all.length, ''),
                        ('Approved', statusCount[AppStrings.approvedLeavesStatusKey]!, AppStrings.approvedLeavesStatusKey),
                        ('Pending', statusCount[AppStrings.pendingLeavesStatusKey]!, AppStrings.pendingLeavesStatusKey),
                        ('Rejected', statusCount[AppStrings.rejectedLeavesStatusKey]!, AppStrings.rejectedLeavesStatusKey),
                        ('Cancelled', statusCount[AppStrings.cancelledLeavesStatusKey]!, AppStrings.cancelledLeavesStatusKey),
                      ];

                      return CommonCardWidget(
                        padding: 5,
                        child: Column(
                          children: items
                              .map(
                                (e) => _SummaryItem(
                              title: e.$1,
                              value: e.$2,
                              color: AppHelper.getLeavesStatusColor(e.$3),
                              vertical: false,
                            ),
                          )
                              .toList(),
                        ),
                      );
                    }),
                  ],
                ),

                const SizedBox(height: 10),
                _buildSummaryAndList(),
              ],
            ),
          ),
        ),

        /// ➕ FAB (APP ONLY)
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
      print('list is the ');
      print(list);

      // Check if list is null or empty
      final bool isEmpty = list == null || list.isEmpty;

      // Default items to show when list is empty
      final List<Map<String, dynamic>> defaultItems = [
        {'name': 'Casual/Sick Leave', 'total': 0, 'balance': 0},
        {'name': 'Annual Leave', 'total': 0, 'balance': 0},
      ];

      if (isEmpty) {
        // Show default cards
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: defaultItems.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: kIsWeb ? 2 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: kIsWeb ? 2.9 : 1.5,
          ),
          itemBuilder: (_, idx) {
            return LeaveBalanceCard(
              balance: LeaveBalance(
                name: defaultItems[idx]['name'],
                total: defaultItems[idx]['total'],
                balance: defaultItems[idx]['balance'],
                id: '',
                // Add any other required fields
              ),
            );
          },
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: kIsWeb ? 2 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: kIsWeb ? 2.9 : 1.5,
        ),
        itemBuilder: (_, idx) {
          return LeaveBalanceCard(balance: list[idx]);
        },
      );
    });
  }

  Widget _buildEmptyBalanceCard(String labelText) {
    return CommonCardWidget(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 LEAVE NAME
          AppTextWidget.medium(
            labelText,
            color: AppThemeColors.textSecondaryColor,
          ),

          const SizedBox(height: 10),

          /// 🔹 PROGRESS BAR (empty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0,
              minHeight: 8,
              backgroundColor: AppThemeColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppThemeColors.textSecondaryColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 STATS ROW (all zeros)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatItem(
                label: 'Total',
                value: '0',
                color: AppThemeColors.textSecondaryColor,
              ),
              StatItem(
                label: 'Available',
                value: '0',
                color: AppThemeColors.textSecondaryColor,
              ),
              StatItem(
                label: 'Used',
                value: '0',
                color: AppThemeColors.textSecondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
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
                  ? const EmptyStateWidget(message: 'No leaves found')
                  : LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 700;

                  if (!isWide) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      itemCount: activeList.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, idx) => LeaveCard(leave: activeList[idx]),
                    );
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                    itemCount: activeList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: isWide ? 3.5 : 1.8, // IMPORTANT: vertical cards
                    ),
                    itemBuilder: (_, idx) => LeaveCard(leave: activeList[idx]),
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

class StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextWidget.medium(
          value,
          color: color,
        ),
        const SizedBox(height: 2),
        AppTextWidget.small(
          label,
          color: AppThemeColors.textSecondaryColor,
        ),
      ],
    );
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
