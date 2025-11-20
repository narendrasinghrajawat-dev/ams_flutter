

import 'package:flutter/material.dart';

class CommonContainerWidget extends StatefulWidget {
  CommonContainerWidget({super.key, required this.child, this.borderRadius = 7, this.padding = 10, this.isShowBoxShadow = true, this.color = Colors.white, this.border});

  Widget child;
  double borderRadius;
  double padding;
  bool isShowBoxShadow;
  Color color;
  final Border? border;



  @override
  State<CommonContainerWidget> createState() => _CommonContainerWidgetState();
}

class _CommonContainerWidgetState extends State<CommonContainerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: BoxDecoration(
        color: widget.color,
        border: widget.border,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow:  [
          widget.isShowBoxShadow == true ?
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0.1, 0.1),
          )
              :
          BoxShadow(),
        ],
      ),
      child: widget.child,
    );
  }
}