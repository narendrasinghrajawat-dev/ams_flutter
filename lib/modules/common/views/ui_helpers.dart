import 'package:flutter/material.dart';

class UIHelpers {
  /// Responsive layout switcher
  /// Mobile  → Column
  /// Tablet+ → Row
  static Widget responsive({
    required BuildContext context,
    required List<Widget> children,
    double spacing = 12,
    double breakpoint = 800,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < breakpoint;

    if (isMobile) {
      return Column(
        crossAxisAlignment: crossAxisAlignment,
        children: _withVerticalSpacing(children, spacing),
      );
    }

    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: _withHorizontalSpacing(children, spacing),
    );
  }

  static List<Widget> _withHorizontalSpacing(
      List<Widget> children,
      double spacing,
      ) {
    final list = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      list.add(Expanded(child: children[i]));
      if (i != children.length - 1) {
        list.add(SizedBox(width: spacing));
      }
    }
    return list;
  }

  static List<Widget> _withVerticalSpacing(
      List<Widget> children,
      double spacing,
      ) {
    final list = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      list.add(children[i]);
      if (i != children.length - 1) {
        list.add(SizedBox(height: spacing));
      }
    }
    return list;
  }
}