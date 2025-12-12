import 'package:attedance_management_system/data/utils/app_helper.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import '../../../../../models/leave_balance.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalance balance;
  const LeaveBalanceCard({Key? key, required this.balance}) : super(key: key);

  // Get color based on leave type
  Color _getLeaveColor() {
    final leaveName = balance.id.toLowerCase();
    if (leaveName.contains('1')) {
      return const Color(0xFF8B5CF6); // Red
    } else if (leaveName.contains('2')) {
      return const Color(0xFF3B82F6); // Blue
    } else {
      return const Color(0xFF6366F1); // Indigo
    }
  }

  // Get icon based on leave type
  IconData _getLeaveIcon() {
    final leaveName = balance.name.toLowerCase();
    if (leaveName.contains('sick')) {
      return Icons.medical_services_rounded;
    } else if (leaveName.contains('casual')) {
      return Icons.beach_access_rounded;
    } else if (leaveName.contains('annual') || leaveName.contains('paid')) {
      return Icons.calendar_month_rounded;
    } else if (leaveName.contains('maternity') || leaveName.contains('paternity')) {
      return Icons.family_restroom_rounded;
    } else if (leaveName.contains('comp')) {
      return Icons.access_time_rounded;
    } else {
      return Icons.event_available_rounded;
    }
  }

  // Calculate percentage
  double _getPercentage() {
    if (balance.total == 0) return 0;
    return (balance.balance / balance.total) * 100;
  }

  // Get status color for percentage
  Color _getStatusColor() {
    final percentage = _getPercentage();
    if (percentage >= 60) {
      return const Color(0xFF10B981); // Green
    } else if (percentage >= 30) {
      return const Color(0xFFF59E0B); // Orange
    } else {
      return const Color(0xFFEF4444); // Red
    }
  }

  @override
  Widget build(BuildContext context) {
    final leaveColor = _getLeaveColor();
    final percentage = _getPercentage();
    final statusColor = _getStatusColor();

    return CommonCardWidget(
      padding: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    leaveColor,
                    leaveColor.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      _getLeaveIcon(),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextWidget.small(
                          balance.name,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 2),
                        AppTextWidget.verySmall(
                          '${percentage.toStringAsFixed(0)}% Available',
                          color: Colors.white.withOpacity(0.9),

                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Body with stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Column(
                children: [

                  // Progress bar
                  Column(
                    children: [
                      SizedBox(height: 5,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppTextWidget.small(
                            'Usage',
                          ),
                          AppTextWidget.small(
                            '${(100 - percentage).toStringAsFixed(0)}% used',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: (balance.total - balance.balance) / balance.total,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(leaveColor),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stats row
                   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                         _buildStatItem(
                          icon: Icons.check_circle_outline_rounded,
                          label: 'Total',
                          value: '${balance.total}',
                          color: leaveColor,
                        ),

                        SizedBox(width: 5,)
,                        _buildStatItem(
                          icon: Icons.event_available_rounded,
                          label: 'Available',
                          value: '${balance.balance}',
                          color: statusColor,
                        ),
                        SizedBox(width: 5,),

                        _buildStatItem(
                          icon: Icons.event_busy_rounded,
                          label: 'Used',
                          value: '${balance.total - balance.balance}',
                          color: Colors.grey.shade600,
                        ),
                      ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 4),
            AppTextWidget.medium(
              value,
              color: color,
            ),
          ],
        ),
        const SizedBox(height: 2),
        AppTextWidget.small(
          label,
        ),
      ],
    );
  }
}