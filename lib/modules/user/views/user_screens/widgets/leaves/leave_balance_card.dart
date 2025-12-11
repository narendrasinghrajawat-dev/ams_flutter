import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:attedance_management_system/core/constants/app_theme_colors.dart';

import '../../../../../models/leave_balance.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalance balance;
  const LeaveBalanceCard({Key? key, required this.balance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(balance.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            Text('${balance.balance}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
    );
  }
}
