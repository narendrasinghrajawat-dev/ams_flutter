import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../core/constants/const_strings.dart';
import '../../../../../models/apply_leave_request.dart';
import '../../../../controller/user_leaves_controller.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';

class LeaveCard extends StatelessWidget {
  final ApplyLeaveRequest leave;
  const LeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context) {
    final statusColor = AppHelper.getLeavesStatusColor(leave.leaveStatus);
    final isPending =
        (leave.leaveStatus ?? '').toLowerCase() ==
            AppStrings.pendingLeavesStatusKey;

    return CommonCardWidget(
      padding: 14,
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Date range + Status Chip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  AppTextWidget.medium(
                    '${AppHelper.formatDateString(leave.startDate)}'
                    ' - ${AppHelper.formatDateString(leave.endDate)}',
                    color: AppThemeColors.textPrimaryColor,
                  ),
                ],
              ),
              _StatusChip(
                label: AppHelper.getLeavesStatusValue(leave.leaveStatus),
                color: statusColor,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Chips: Duration & Days
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _Chip(
                '${leave.numberOfLeaves} Day${leave.numberOfLeaves > 1 ? 's' : ''}',
                AppThemeColors.secondaryColor,
              ),
              _Chip(
                leave.leaveDurationsType == AppStrings.halfDayKey
                    ? 'Half Day'
                    : 'Full Day',
                AppThemeColors.warningColor,
              ),
              if (!AppHelper.isEmptyOrNull(leave.halfDayShiftType))
                _Chip(
                  leave.halfDayShiftType!,
                  AppThemeColors.primaryColor,
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Details
          if ((leave.reason ?? '').isNotEmpty)
            _DetailRow('Reason', leave.reason!, Icons.note_outlined),

          if (leave.approverByName != null && leave.approverByName!.isNotEmpty)
            _DetailRow('Approved by', leave.approverByName!, Icons.person_outline),

          if (leave.actionDate != null && leave.actionDate!.isNotEmpty)
            _DetailRow(
              'Action date',
              AppHelper.formatDateString(leave.actionDate!),
              Icons.calendar_today_outlined,
            ),

          // Cancel Button for Pending
          if (isPending) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton.icon(
                onPressed: () => Get.find<UserLeavesController>().onCancelLeave(leave),
                icon: const Icon(Icons.close_rounded, size: 16),
                label: const Text('Cancel Request', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppThemeColors.errorColor,
                  side: BorderSide(color: AppThemeColors.errorColor.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: AppThemeColors.textSecondaryColor),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: AppThemeColors.textSecondaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: AppThemeColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
