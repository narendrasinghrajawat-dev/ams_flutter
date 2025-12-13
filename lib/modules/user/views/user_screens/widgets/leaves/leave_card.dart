// leave_card.dart
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import '../../../../../../core/constants/const_strings.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../../models/apply_leave_request.dart';
import '../../../../controller/user_leaves_controller.dart';

class LeaveCard extends StatelessWidget {
  final ApplyLeaveRequest leave;
  const LeaveCard({Key? key, required this.leave}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = (leave.leaveStatus ?? '').toLowerCase();
    final isPending = status == AppStrings.pendingLeavesStatusKey;
    final statusColor = AppHelper.getLeavesStatusColor(leave.leaveStatus);

    return CommonCardWidget(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Calendar Icon, Date Range & Status Badge
          Row(
            children: [
              // Calendar Icon Container
              _CalendarIconWidget(statusColor: statusColor),
              const SizedBox(width: 12),

              // Date Range
              Expanded(
                child: _DateRangeWidget(
                  startDate: leave.startDate,
                  endDate: leave.endDate,
                ),
              ),

              const SizedBox(width: 8),

              // Status Badge
              _StatusBadge(
                status: AppHelper.getLeavesStatusValue(leave.leaveStatus),
                color: statusColor,
              ),
            ],
          ),

          const SizedBox(height: 16),


          ListTileTheme(
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              dense: true,
              child: ExpansionTile(
                initiallyExpanded: false,
                childrenPadding: EdgeInsets.zero,
                shape: const Border(bottom: BorderSide.none),
                collapsedShape: const Border(bottom: BorderSide(width: 1.5, color: Colors.white)),
                dense: true,
                onExpansionChanged: (value) {
                },
                minTileHeight: 30,
                tilePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                collapsedBackgroundColor:  AppThemeColors.collapsedBackgroundColor,
                collapsedIconColor:AppThemeColors.collapsedIconColor,
                iconColor: AppThemeColors.collapsedIconColor,


                title: AppTextWidget.medium("More Details"),
                children: [
                  Column(
                    children: [
                      // Divider
                      Divider(height: 1, thickness: 1, color: Colors.grey.shade200),

                      const SizedBox(height: 5),

                      // Leave Type & Action Date Row
                      Row(
                        children: [
                          _LeaveTypeChip(leaveType: AppHelper.getLeaveType(leave.leaveType) ?? '-'),
                          const Spacer(),
                          if (leave.actionDate != null)
                            _ActionDateChip(actionDate: leave.actionDate!),
                        ],
                      ),

                      SizedBox(height: 10,),
                      // Info Grid
                      _InfoGrid(
                        numberOfLeaves: leave.numberOfLeaves.toString(),
                        durationType: leave.leaveDurationsType == AppStrings.halfDayKey
                            ? 'Half Day'
                            : 'Full Day',
                        approverName: leave.approverByName ?? '-',
                      ),

                      // Reason Section
                      if ((leave.reason ?? '').isNotEmpty) ...[
                        const SizedBox(height: 16),
                        _ReasonSection(reason: leave.reason!),
                      ],

                      // Cancel Button
                      if (isPending) ...[
                        const SizedBox(height: 16),
                        _CancelButton(
                          onPressed: () =>
                              Get.find<UserLeavesController>().onCancelLeave(leave),
                        ),
                      ],
                    ],
                  )
                ],
              ))

        ],
      ),
    );
  }
}

// ===== COMMON WIDGETS =====

// Calendar Icon with Gradient Background
class _CalendarIconWidget extends StatelessWidget {
  final Color statusColor;
  const _CalendarIconWidget({required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            statusColor.withOpacity(0.2),
            statusColor.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.calendar_month_rounded,
        size: 24,
        color: statusColor,
      ),
    );
  }
}

// Date Range Display
class _DateRangeWidget extends StatelessWidget {
  final String startDate;
  final String endDate;
  const _DateRangeWidget({required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextWidget.medium(
          AppHelper.formatDateString(startDate),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.arrow_downward_rounded, size: 12, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            AppTextWidget.small(
              AppHelper.formatDateString(endDate),
            ),
          ],
        ),
      ],
    );
  }
}

// Status Badge with Dot Indicator
class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;
  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          AppTextWidget.small(
            status,
            color: color,
          ),
        ],
      ),
    );
  }
}

// Leave Type Chip
class _LeaveTypeChip extends StatelessWidget {
  final String leaveType;
  const _LeaveTypeChip({required this.leaveType});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child:Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.event_note_rounded,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 7),
          AppTextWidget.small(
            leaveType,
          ),
        ],
      ),
    );
  }
}

// Action Date Chip
class _ActionDateChip extends StatelessWidget {
  final String actionDate;
  const _ActionDateChip({required this.actionDate});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 5),
          AppTextWidget.small(
            AppHelper.formatDateString(actionDate),
          ),
        ],
    );
  }
}

// Info Grid with Three Columns
class _InfoGrid extends StatelessWidget {
  final String numberOfLeaves;
  final String durationType;
  final String approverName;

  const _InfoGrid({
    required this.numberOfLeaves,
    required this.durationType,
    required this.approverName,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Row(
        children: [
          Expanded(
            child: _InfoColumn(
              icon: Icons.today_rounded,
              iconColor: Colors.purple.shade400,
              title: 'Days',
              value: numberOfLeaves,
            ),
          ),
          Container(
            width: 1,
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _InfoColumn(
              icon: Icons.schedule_rounded,
              iconColor: Colors.orange.shade400,
              title: 'Mode',
              value: durationType,
            ),
          ),
          Container(
            width: 1,
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: _InfoColumn(
              icon: Icons.person_rounded,
              iconColor: Colors.teal.shade400,
              title: 'Action By',
              value: approverName,
            ),
          ),
        ],
      ),
    );
  }
}

// Info Column Widget
class _InfoColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _InfoColumn({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(height: 8),
        AppTextWidget.small(
          title,
        ),
        const SizedBox(height: 4),
        AppTextWidget.medium(
          value,
        ),
      ],
    );
  }
}

// Reason Section
class _ReasonSection extends StatelessWidget {
  final String reason;
  const _ReasonSection({required this.reason});

  @override
  Widget build(BuildContext context) {
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    CommonCardWidget(
                      color: Colors.amber.shade100,

                      child: Icon(
                        Icons.comment,
                        size: 14,
                        color: Colors.amber.shade800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AppTextWidget.medium(
                      'Reason',
                      color: Colors.amber.shade900,
                    ),
                  ],
                ),
              ),

              AppTextWidget.small(
                reason,
              ),

            ],
          ),

        ],
    );
  }
}

// Cancel Button
class _CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const _CancelButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red.shade600,
          side: BorderSide(color: Colors.red.shade200, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: Icon(Icons.cancel_outlined, size: 20, color: Colors.red.shade600),
        label: AppTextWidget.medium(
          'Cancel Request',
          color: Colors.red.shade600,
        ),
      ),
    );
  }
}