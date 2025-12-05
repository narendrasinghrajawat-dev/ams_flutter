import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/models/apply_leave_request.dart';
import 'package:attedance_management_system/views/user/user_screens/forms/user_apply_leaves_form.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/user_controller.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/common/common_dialong_box.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';

class UserLeavesScreen extends StatefulWidget {
  const UserLeavesScreen({Key? key}) : super(key: key);

  @override
  State<UserLeavesScreen> createState() => _UserLeavesScreenState();
}

class _UserLeavesScreenState extends State<UserLeavesScreen> {
  /// 0 = Approved, 1 = Pending, 2 = Rejected
  int _activeTab = 0;

  final UserController _userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                AppTextWidget.large('All Leaves',
                    color: AppThemeColors.textPrimaryColor),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showCommonDialog(
                      context: context,
                      child: const UserApplyLeavesForm(),
                    );
                  },
                  icon: Icon(Icons.add, color: AppThemeColors.iconColor),
                ),
                IconButton(
                  onPressed: () {
                    // TODO: filter/sorting if needed
                  },
                  icon: Icon(Icons.tune, color: AppThemeColors.iconColor),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Everything below depends on controller data
            Obx(() {
              final List<ApplyLeaveRequest> all = _userController.filteredAppliedLeavesList;

              // Group by status (lowercase for safety)
              final approved = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == 'approved').toList();
              final pending = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == 'pending').toList();
              final rejected = all.where((e) => (e.leaveStatus ?? '').toLowerCase() == 'rejected').toList();

              // Active list based on tab
              List<ApplyLeaveRequest> activeList;
              if (_activeTab == 0) {
                activeList = approved;
              } else if (_activeTab == 1) {
                activeList = pending;
              } else {
                activeList = rejected;
              }

              // Build summary cards data (dynamic)
              final summary = [
                {
                  'title': 'Total Applied',
                  'value': all.length.toString(),
                },
                {
                  'title': 'Approved',
                  'value': approved.length.toString(),
                },
                {
                  'title': 'Pending',
                  'value': pending.length.toString(),
                },
                {
                  'title': 'Rejected',
                  'value': rejected.length.toString(),
                },
              ];

              return Expanded(
                child: Column(
                  children: [
                    // Summary 2x2 grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: summary.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 75,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1.6,
                      ),
                      itemBuilder: (ctx, idx) {
                        final s = summary[idx];
                        return _SummaryCard(
                          title: s['title']!,
                          value: s['value']!,
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    // Segmented tabs (Approved / Pending / Rejected)
                    CommonContainerWidget(
                      child: Row(
                        children: [
                          _segButton('Approved', 0),
                          _segButton('Pending', 1),
                          _segButton('Rejected', 2),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // List of leave cards / empty state
                    Expanded(
                      child: activeList.isEmpty
                          ? Center(
                        child: AppTextWidget.small(
                          'No leaves found',
                          color: AppThemeColors.muted,
                        ),
                      )
                          : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        itemCount: activeList.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 10),
                        itemBuilder: (ctx, idx) {
                          final leave = activeList[idx];
                          return _LeaveCard(leave: leave);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _segButton(String label, int index) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color:
            selected ? AppThemeColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: AppTextWidget.small(
            label,
            color: selected
                ? AppThemeColors.whiteColor
                : AppThemeColors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget.small(title, color: AppThemeColors.textPrimaryColor),
          const Spacer(),
          AppTextWidget.large(value, color: AppThemeColors.primaryColor),
        ],
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final ApplyLeaveRequest leave;
  const _LeaveCard({required this.leave, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final status = (leave.leaveStatus ?? 'pending');
    print('status is the $status');


    final appliedAt = leave.actionDate ?? ''; // e.g. 2025-12-04T13:13...

    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: date range & status chip
          Row(
            children: [
              Expanded(
                child: AppTextWidget.small(
                  "${AppHelper.formatDateString(leave.startDate)} - ${AppHelper.formatDateString(leave.endDate)}" ,
                  color: AppThemeColors.textPrimaryColor,
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppHelper.getLeavesStatusColor(leave.leaveStatus).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppHelper.getLeavesStatusColor(leave.leaveStatus).withOpacity(0.6)),
                ),
                child: AppTextWidget.verySmall(
                  status.capitalizeFirst ?? status,
                  color: AppHelper.getLeavesStatusColor(leave.leaveStatus),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Leave type + applied at
          Row(
            children: [
              Icon(Icons.event_note,
                  size: 16, color: AppThemeColors.iconColor),
              const SizedBox(width: 4),
              AppTextWidget.small(
                leave.leaveType ?? '-',
                color: AppThemeColors.textPrimaryColor,
              ),
              const Spacer(),
              if (appliedAt.isNotEmpty) ...[
                Icon(Icons.access_time,
                    size: 14, color: AppThemeColors.iconColor),
                const SizedBox(width: 4),
                AppTextWidget.verySmall(
                  appliedAt,
                  color: AppThemeColors.muted,
                ),
              ],
            ],
          ),

          const SizedBox(height: 10),

          // Detail row: days, full/half, approver
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget.verySmall('Applied Days',
                        color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 4),
                    AppTextWidget.small(leave.numberOfLeaves.toString(),
                        color: AppThemeColors.textPrimaryColor),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget.verySmall('Mode',
                        color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 4),
                    AppTextWidget.small(
                      leave.leaveDurationsType == AppStrings.halfDayKey ? 'Half Day' : 'Full Day',
                      color: AppThemeColors.textPrimaryColor,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextWidget.verySmall('Approved By',
                        color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 4),
                    AppTextWidget.small(
                      leave.approverByName ?? '-',
                      color: AppThemeColors.textPrimaryColor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Reason (one or two lines)
          if ((leave.reason ?? '').isNotEmpty) ...[
            AppTextWidget.verySmall('Reason',
                color: AppThemeColors.textSecondaryColor),
            const SizedBox(height: 4),
            AppTextWidget.small(
              leave.reason ?? '',
              color: AppThemeColors.textPrimaryColor,
              maxLines: 2,
            ),
          ],
        ],
      ),
    );
  }
}
