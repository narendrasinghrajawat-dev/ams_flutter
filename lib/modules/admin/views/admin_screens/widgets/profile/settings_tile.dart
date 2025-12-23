
import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';


class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon),
        title: AppTextWidget.medium(title),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
