

import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/common/ui_helper_widgets.dart';
import '../../../../../models/user.dart';
import 'info_row.dart';


class ProfileInfoCard extends StatelessWidget {
  final User user;

  const ProfileInfoCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Column(
        children: [
          InfoRow(
            icon: Icons.person,
            label: 'Name',
            value:
            '${user.firstName ?? ''} ${user.lastName ?? ''}',
          ),
          UIHelper.showDivider(),
          InfoRow(
            icon: Icons.email,
            label: 'Email',
            value: user.email ?? '-',
          ),
          UIHelper.showDivider(),
          InfoRow(
            icon: Icons.phone,
            label: 'Phone',
            value: user.phoneNo ?? '-',
          ),
        ],
      ),
    );
  }
}
