

import 'package:flutter/material.dart';

import '../../../../../../widgets/common/ui_helper_widgets.dart';

class ResponsiveInfoGrid extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveInfoGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isWide = constraints.maxWidth >= 700;

        if (!isWide) {
          // 📱 Mobile
          return Column(
            children: _withDividers(children),
          );
        }

        // 🌐 Web / Desktop
        return Column(
          children: _buildRows(children),
        );
      },
    );
  }

  List<Widget> _buildRows(List<Widget> items) {
    List<Widget> rows = [];

    for (int i = 0; i < items.length; i += 2) {
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: items[i]),
            const SizedBox(width: 16),
            Expanded(
              child: i + 1 < items.length ? items[i + 1] : const SizedBox(),
            ),
          ],
        ),
      );

      if (i + 2 < items.length) {
        rows.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: UIHelper.showDivider(),
          ),
        );
      }
    }

    return rows;
  }


  List<Widget> _withDividers(List<Widget> items) {
    return [
      for (int i = 0; i < items.length; i++) ...[
        items[i],
        if (i != items.length - 1) UIHelper.showDivider(),
      ]
    ];
  }
}
