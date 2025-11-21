import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:attedance_management_system/widgets/container/common_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/app_text_type.dart';

class UserLeavesScreen extends StatefulWidget {
  const UserLeavesScreen({Key? key}) : super(key: key);

  @override
  State<UserLeavesScreen> createState() => _UserLeavesScreenState();
}

class _UserLeavesScreenState extends State<UserLeavesScreen> {
  int _activeTab = 0; // 0 = Approved, 1 = Pending, 2 = Rejected

  // Summary values (you can compute these dynamically from the lists)
  final List<Map<String, dynamic>> _summary = [
    {'title': 'Leave Balance', 'value': '20'},
    {'title': 'Leave Approved', 'value': '2'},
    {'title': 'Leave Pending', 'value': '4'},
    {'title': 'Leave Rejected', 'value': '10'},
  ];

  // Dummy leave items grouped by status
  final List<Map<String, dynamic>> _approved = [
    {
      'range': 'Apr 15, 2023 - Apr 18, 2023',
      'days': 3,
      'balance': 16,
      'approvedBy': 'Martin Deo',
      'status': 'Approved'
    },
    {
      'range': 'Mar 02, 2023 - Mar 03, 2023',
      'days': 2,
      'balance': 18,
      'approvedBy': 'HR',
      'status': 'Approved'
    },
  ];

  final List<Map<String, dynamic>> _pending = [
    {
      'range': 'May 05, 2023 - May 06, 2023',
      'days': 2,
      'balance': 14,
      'approvedBy': 'Manager',
      'status': 'Pending'
    },
    {
      'range': 'Jun 01, 2023 - Jun 02, 2023',
      'days': 2,
      'balance': 12,
      'approvedBy': '-',
      'status': 'Pending'
    },
  ];

  final List<Map<String, dynamic>> _rejected = [
    {
      'range': 'Feb 10, 2023 - Feb 11, 2023',
      'days': 2,
      'balance': 10,
      'approvedBy': 'Manager',
      'status': 'Rejected'
    },
  ];

  List<Map<String, dynamic>> get _activeList {
    if (_activeTab == 0) return _approved;
    if (_activeTab == 1) return _pending;
    return _rejected;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12),
        child: Column(
          children: [
            // Header row
            Row(
              children: [
                AppTextWidget.large('All Leaves', color: AppThemeColors.textPrimaryColor),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.add, color: AppThemeColors.iconColor),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.tune, color: AppThemeColors.iconColor),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Summary 2x2 grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _summary.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 75,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.6,
              ),
              itemBuilder: (ctx, idx) {
                final s = _summary[idx];
                return _SummaryCard(
                    title: s['title']!,
                    value: s['value']!
                );
              },
            ),

            const SizedBox(height: 14),

            // Segmented tabs (Approved / Pending / Rejected)
            CommonContainerWidget(
              child: Row(
                children: [
                  _segButton('Approved', 0),
                  _segButton('Pending', 1),
                  _segButton('Rejected', 2),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // List heading + container
            Align(
              alignment: Alignment.centerLeft,
              child: AppTextWidget.medium(
                _activeTab == 0 ? 'Approved' : (_activeTab == 1 ? 'Pending' : 'Rejected'),
                color: AppThemeColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 10),

            // List of leave cards
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: _activeList.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, idx) {
                  final item = _activeList[idx];
                  return _LeaveCard(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segButton(String label, int index) {
    final selected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = index),
        child: Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: selected ? AppThemeColors.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: AppTextWidget.small(label, color: selected ? AppThemeColors.whiteColor : AppThemeColors.textSecondaryColor),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget.small(title, color: AppThemeColors.textPrimaryColor),
          const Spacer(),
          AppTextWidget.large(value, color: AppThemeColors.primaryColor),
        ],
      ),
    );
  }
}

class _LeaveCard extends StatelessWidget {
  final Map<String, dynamic> item;
  const _LeaveCard({required this.item, Key? key}) : super(key: key);

  Color _statusColor(String s) {
    if (s.toLowerCase() == 'approved') return AppThemeColors.successColor;
    if (s.toLowerCase() == 'pending') return AppThemeColors.warningColor;
    if (s.toLowerCase() == 'rejected' || s.toLowerCase() == 'cancelled') return AppThemeColors.errorColor;
    return AppThemeColors.muted;
  }

  @override
  Widget build(BuildContext context) {
    final status = (item['status'] ?? '').toString();
    return CommonCardWidget(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row: date range and status chip
            Row(
              children: [
                Expanded(child: AppTextWidget.small(item['range'] ?? '-', color: AppThemeColors.textPrimaryColor)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _statusColor(status).withOpacity(0.6)),
                  ),
                  child: AppTextWidget.verySmall(status.capitalizeFirst ?? status, color: _statusColor(status)),
                )
              ],
            ),

            const SizedBox(height: 12),

            // detail row
            Row(
              children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AppTextWidget.verySmall('Apply Days', color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 6),
                    AppTextWidget.small('${item['days'] ?? '-'}', color: AppThemeColors.textPrimaryColor),
                  ]),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AppTextWidget.verySmall('Leave Balance', color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 6),
                    AppTextWidget.small('${item['balance'] ?? '-'}', color: AppThemeColors.textPrimaryColor),
                  ]),
                ),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    AppTextWidget.verySmall('Approved By', color: AppThemeColors.textSecondaryColor),
                    const SizedBox(height: 6),
                    AppTextWidget.small('${item['approvedBy'] ?? '-'}', color: AppThemeColors.textPrimaryColor),
                  ]),
                ),
              ],
            )
          ],
        ),
    );
  }
}
