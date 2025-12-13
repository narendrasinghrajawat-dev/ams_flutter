

import 'package:flutter/material.dart';

class AdminQuickTabs extends StatelessWidget {
  const AdminQuickTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _TabChip("Overview", true),
          _TabChip("Attendance", false),
          _TabChip("Leaves", false),
          _TabChip("Employees", false),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _TabChip(this.label, this.selected);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) {},
      ),
    );
  }
}

