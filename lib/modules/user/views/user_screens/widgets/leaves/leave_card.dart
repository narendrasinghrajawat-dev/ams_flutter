// leave_card.dart
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_icons_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../../core/constants/const_strings.dart';
import '../../../../../models/apply_leave_request.dart';
import '../../../../controller/user_leaves_controller.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';

class LeaveCard extends StatelessWidget {
  final ApplyLeaveRequest leave;
  const LeaveCard({super.key, required this.leave});

  bool _isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 700;

  @override
  Widget build(BuildContext context) {

    final statusColor = AppHelper.getLeavesStatusColor(leave.leaveStatus);
    final isPending =
        (leave.leaveStatus ?? '').toLowerCase() ==
            AppStrings.pendingLeavesStatusKey;

    return CommonCardWidget(
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _StatusDot(color: statusColor),
              AppTextWidget.medium(
                '${AppHelper.formatDateString(leave.startDate)}'
                    ' - ${AppHelper.formatDateString(leave.endDate)}',
              ),
              _StatusChip(
                label: AppHelper.getLeavesStatusValue(leave.leaveStatus),
                color: statusColor,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ================= META =================
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _Chip(
                '${leave.numberOfLeaves} Day${leave.numberOfLeaves > 1 ? 's' : ''}',
                Colors.blue,
              ),
              _Chip(
                leave.leaveDurationsType == AppStrings.halfDayKey
                    ? 'Half Day'
                    : 'Full Day',
                Colors.orange,
              ),
              if (!AppHelper.isEmptyOrNull(leave.halfDayShiftType ))
                _Chip(leave.halfDayShiftType!, Colors.purple),
            ],
          ),

          const SizedBox(height: 14),

          // ================= DETAILS =================
          if ((leave.reason ?? '').isNotEmpty)
            _DetailRow('Reason', leave.reason!, Icons.note_outlined),

          if (leave.approverByName != null)
            _DetailRow('Approved by', leave.approverByName!, Icons.person),

          if (leave.actionDate != null)
            _DetailRow(
              'Action date',
              AppHelper.formatDateString(leave.actionDate!),
              Icons.calendar_today,
            ),

          // ================= BUTTON =================
          if (isPending) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Get.find<UserLeavesController>()
                    .onCancelLeave(leave),
                icon: const Icon(Icons.close, size: 18),
                label: const Text('Cancel Request'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ================= SMALL WIDGETS =================

class _StatusDot extends StatelessWidget {
  final Color color;
  const _StatusDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: AppTextWidget.verySmall(label, color: color),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppTextWidget.verySmall(label, color: color),
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
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
              child: Row(
                children: [
                  AppIconWidget.medium(icon),
                  const SizedBox(width: 6),
                  AppTextWidget.small(label, color: Colors.grey.shade600),],)),
          AppTextWidget.small(
            value,
          ),
        ],
      ),
    );
  }
}
