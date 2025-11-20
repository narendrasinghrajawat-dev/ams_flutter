

import 'package:flutter/material.dart';

import '../../core/constants/app_theme_colors.dart';

class CommonCardWidget extends StatefulWidget {
  CommonCardWidget({super.key, required this.child, this.borderRadius = 7, this.padding = 10, this.isShowBoxShadow = true, this.color, this.border});

  Widget child;
  double borderRadius;
  double padding;
  bool isShowBoxShadow;
  Color? color;
  final Border? border;



  @override
  State<CommonCardWidget> createState() => _CommonCardWidgetState();
}

class _CommonCardWidgetState extends State<CommonCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: BoxDecoration(
        color: widget.color ?? AppThemeColors.cardBackgroundColor,
        border: widget.border ?? Border.all(width: 1, color: AppThemeColors.cardBorderColor),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: widget.child,
    );
  }
}


