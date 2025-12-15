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

  num get _used => balance.total > 0 ? balance.total - balance.balance : 0;

  double get _usagePercent =>
      balance.total > 0 ? _used / balance.total : 0;

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 LEAVE NAME
          AppTextWidget.medium(
            balance.name,
            color: AppThemeColors.textPrimaryColor,
          ),

          const SizedBox(height: 10),


          /// 🔹 PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _usagePercent,
              minHeight: 8,
              backgroundColor: AppThemeColors.borderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppThemeColors.usedColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔹 STATS ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                label: 'Total',
                value: balance.total.toString(),
                color: AppThemeColors.totalColor,
              ),
              _StatItem(
                label: 'Available',
                value: balance.balance.toString(),
                color: AppThemeColors.availableColor,
              ),
              _StatItem(
                label: 'Used',
                value: _used.toStringAsFixed(0),
                color: AppThemeColors.usedColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
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
