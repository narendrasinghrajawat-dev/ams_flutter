

import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_theme_colors.dart';

class UserActionMenu extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onChangePassword;
  final VoidCallback onDelete;

  const UserActionMenu({
    super.key,
    required this.onEdit,
    required this.onChangePassword,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.all(0),
      menuPadding: EdgeInsets.all(0),

      color: AppThemeColors.popupBackgroundColor,
      icon: Icon(Icons.more_vert, color: AppThemeColors.iconColor),
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'password':
            onChangePassword();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(

          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 10,
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit'),
          ),
        ),
        const PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 10),
          value: 'password',
          child: ListTile(
            leading: Icon(Icons.lock_reset),
            title: Text('Change Password'),
          ),
        ),
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 10),
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete, color: AppThemeColors.errorColor),
            title: Text(
              'Delete',
              style: TextStyle(color: AppThemeColors.errorColor),
            ),
          ),
        ),
      ],
    );
  }
}
