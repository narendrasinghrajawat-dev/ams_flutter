

import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_theme_colors.dart';


class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onEdit;

  const ProfileAvatar({
    super.key,
    required this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(imageUrl),
        ),
        Positioned(
          right: 0,
          top: 4,
          child: InkWell(
            onTap: onEdit,
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppThemeColors.primaryColor,
              child: Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
