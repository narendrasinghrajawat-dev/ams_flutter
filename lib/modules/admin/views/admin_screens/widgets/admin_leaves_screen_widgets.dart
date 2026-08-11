

import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/common/ui_helper_widgets.dart';
import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/apply_leave_request.dart';

// Helper function to get color based on status
Color _getStatusColor(String? status) {
  if (status == AppStrings.approvedLeavesStatusKey) return AppThemeColors.successColor;
  if (status == AppStrings.rejectedLeavesStatusKey) return AppThemeColors.errorColor;
  return AppThemeColors.warningColor; // Pending or Unknown
}

// Widget to display the leave request item
class LeaveRequestListItem extends StatelessWidget {
  final ApplyLeaveRequest leaveRequest;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const LeaveRequestListItem({
    required this.leaveRequest,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(leaveRequest.leaveStatus);
    final isPending = leaveRequest.leaveStatus == AppStrings.pendingLeavesStatusKey;

    return CommonCardWidget(
     child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Employee Name and Leave Type (Top Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget.medium(
                  leaveRequest.userName ?? 'N/A',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppThemeColors.primaryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: AppTextWidget.small(
                  AppHelper.getLeaveType(leaveRequest.leaveType) ?? "",
                  color: AppThemeColors.primaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // 2. Dates and Number of Days (Middle Row)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date Range
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 14, color: AppThemeColors.muted),
                  const SizedBox(width: 4),
                  AppTextWidget.small(
                    '${AppHelper.formatDateString(leaveRequest.startDate)}  ${AppHelper.formatDateString(leaveRequest.endDate)}',
                    color: AppThemeColors.textSecondaryColor,
                  ),
                ],
              ),
              // Number of Days
              Row(
                children: [

                  AppTextWidget.small(
                    '${leaveRequest.numberOfLeaves} Days',
                    color: AppThemeColors.textSecondaryColor,
                  ),
                  SizedBox(width: 5,),

                  if(leaveRequest.halfDayShiftType != null)
                    AppTextWidget.small(
                      AppHelper.getHalfDayLeaveName(leaveRequest.halfDayShiftType),
                      color: AppThemeColors.textSecondaryColor,
                    ),
                ],
              )
            ],
          ),

          const SizedBox(height: 10),

          // 3. Reason (Expanded Description)
          AppTextWidget.small(
            'Reason : ${leaveRequest.reason}',
            color: AppThemeColors.muted,
            maxLines: 2,
          ),


          isPending
              ? _buildPendingActions()
              : _buildStatusDisplay(leaveRequest.leaveStatus, statusColor),
        ],
      ),
    );
  }

  // Widget for Pending status with action buttons
  Widget _buildPendingActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppTextWidget.small('Action:', color: AppThemeColors.textSecondaryColor),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Approve Leave',
          child: InkWell(
            onTap: onApprove,
            child: Icon(Icons.check_circle_outline, size: 28, color: AppThemeColors.successColor),
          ),
        ),
        const SizedBox(width: 8),
        Tooltip(
          message: 'Reject Leave',
          child: InkWell(
            onTap: onReject,
            child: Icon(Icons.cancel_outlined, size: 28, color: AppThemeColors.errorColor),
          ),
        ),
      ],
    );
  }

  // Widget for Approved/Rejected status display
  Widget _buildStatusDisplay(String? status, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppTextWidget.small(
          leaveRequest.actionDate != null ? 'Action Date: ${AppHelper.formatDateString(leaveRequest.actionDate)}' : '',
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: AppTextWidget.verySmall(
            AppHelper.getLeavesStatusValue(status),
            color: AppThemeColors.whiteColor,
          ),
        ),
      ],
    );
  }
}