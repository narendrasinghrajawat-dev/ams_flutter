import 'package:flutter/material.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import '../../../../../models/leave_balance.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalance balance;

  const LeaveBalanceCard({
    Key? key,
    required this.balance,
  }) : super(key: key);

  num get _used => balance.total > 0 ? (balance.total - balance.balance).clamp(0, balance.total) : 0;

  double get _usagePercent =>
      balance.total > 0 ? (_used / balance.total).clamp(0.0, 1.0) : 0.0;

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;

    return CommonCardWidget(
      padding: 14,
      borderRadius: 14,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Name + Available Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AppTextWidget.medium(
                  balance.name,
                  color: AppThemeColors.textPrimaryColor,
                  maxLines: 1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppThemeColors.successColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${balance.balance} left',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppThemeColors.successColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: _usagePercent,
              minHeight: 6,
              backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(
                _usagePercent > 0.8 ? AppThemeColors.errorColor : AppThemeColors.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatPill(
                label: 'Total',
                value: '${balance.total}',
                color: AppThemeColors.totalColor,
              ),
              _StatPill(
                label: 'Available',
                value: '${balance.balance}',
                color: AppThemeColors.availableColor,
              ),
              _StatPill(
                label: 'Used',
                value: '$_used',
                color: AppThemeColors.usedColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppThemeColors.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppThemeColors.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
