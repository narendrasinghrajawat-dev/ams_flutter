import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../../core/constants/app_theme_colors.dart';
import '../../../../../../data/utils/app_helper.dart';
import '../../../../controller/user_home_controller.dart';
import '../../../../model/user_calendar.dart';

class YearCalendarScreen extends StatefulWidget {
  const YearCalendarScreen({super.key});

  @override
  State<YearCalendarScreen> createState() => _YearCalendarScreenState();
}

class _YearCalendarScreenState extends State<YearCalendarScreen> {
  final UserHomeController _controller = Get.find<UserHomeController>();
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchCalendar();
  }

  void _fetchCalendar() {
    _controller.getUserCalendar(_currentDate.year.toString());
  }

  void _prevMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1, 1);
    });
    _fetchCalendar();
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1, 1);
    });
    _fetchCalendar();
  }

  void _resetToday() {
    setState(() {
      _currentDate = DateTime.now();
    });
    _fetchCalendar();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final year = _currentDate.year;
    final month = _currentDate.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday % 7; // 0 = Sun, 1 = Mon ...
    final monthName = DateFormat.MMMM().format(_currentDate);
    final today = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(today);

    return Scaffold(
      backgroundColor: AppThemeColors.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Attendance Calendar'),
        backgroundColor: AppThemeColors.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _resetToday,
            icon: const Icon(Icons.today, size: 18),
            label: const Text('Today'),
            style: TextButton.styleFrom(
              foregroundColor: AppThemeColors.primaryColor,
            ),
          ),
        ],
      ),
      body: Obx(() {
        final response = _controller.userCalendar.value;
        final dataMap = response?.data ?? <String, CalendarDay>{};

        // Compute summary for this month
        int presentCount = 0;
        int leaveCount = 0;
        int holidayCount = 0;
        int absentCount = 0;

        for (int d = 1; d <= daysInMonth; d++) {
          final dDate = DateTime(year, month, d);
          final dStr = DateFormat('yyyy-MM-dd').format(dDate);
          final dayInfo = dataMap[dStr];
          final isWeekend = dDate.weekday == DateTime.saturday || dDate.weekday == DateTime.sunday;
          final isPast = dStr.compareTo(todayStr) < 0;

          final isPresent = dayInfo?.status == 'present' || dayInfo?.punch != null;
          final isLeave = dayInfo?.status == 'leave' || dayInfo?.leave != null;
          final isHoliday = (dayInfo?.isHoliday == true) && !isWeekend;
          final isAbsent = !isPresent && !isLeave && !isHoliday && !isWeekend && isPast;

          if (isPresent) presentCount++;
          else if (isLeave) leaveCount++;
          else if (isHoliday) holidayCount++;
          else if (isAbsent) absentCount++;
        }

        return RefreshIndicator(
          onRefresh: () async => _fetchCalendar(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Navigation Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppThemeColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppThemeColors.borderColor, width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded),
                        onPressed: _prevMonth,
                        color: AppThemeColors.textPrimaryColor,
                      ),
                      Text(
                        '$monthName $year',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppThemeColors.textPrimaryColor,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded),
                        onPressed: _nextMonth,
                        color: AppThemeColors.textPrimaryColor,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Summary Stats Cards
                Row(
                  children: [
                    _buildStatChip('Present', '$presentCount', Colors.green, Icons.check_circle_outline),
                    const SizedBox(width: 8),
                    _buildStatChip('Leaves', '$leaveCount', Colors.orange, Icons.beach_access_outlined),
                    const SizedBox(width: 8),
                    _buildStatChip('Holidays', '$holidayCount', Colors.blue, Icons.celebration_outlined),
                    const SizedBox(width: 8),
                    _buildStatChip('Absent', '$absentCount', Colors.red, Icons.cancel_outlined),
                  ],
                ),

                const SizedBox(height: 16),

                // Calendar Grid Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppThemeColors.cardBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppThemeColors.borderColor, width: 0.8),
                  ),
                  child: Column(
                    children: [
                      // Weekday Headers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                            .asMap()
                            .entries
                            .map((entry) {
                          final isWeekendHeader = entry.key == 0 || entry.key == 6;
                          return Expanded(
                            child: Center(
                              child: Text(
                                entry.value,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: isWeekendHeader
                                      ? AppThemeColors.muted
                                      : AppThemeColors.textSecondaryColor,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 10),
                      const Divider(height: 1),
                      const SizedBox(height: 10),

                      // Days Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: firstWeekday + daysInMonth,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          if (index < firstWeekday) {
                            return const SizedBox.shrink();
                          }

                          final day = index - firstWeekday + 1;
                          final date = DateTime(year, month, day);
                          final dateStr = DateFormat('yyyy-MM-dd').format(date);
                          final isToday = today.year == year && today.month == month && today.day == day;
                          final isWeekend = date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
                          final isPast = dateStr.compareTo(todayStr) < 0;

                          final dayInfo = dataMap[dateStr];
                          final isPresent = dayInfo?.status == 'present' || dayInfo?.punch != null;
                          final isLeave = dayInfo?.status == 'leave' || dayInfo?.leave != null;
                          final isHoliday = (dayInfo?.isHoliday == true) && !isWeekend;
                          final isAbsent = !isPresent && !isLeave && !isHoliday && !isWeekend && isPast;

                          Color bgColor = AppThemeColors.cardBackgroundColor;
                          Color borderColor = AppThemeColors.borderColor;
                          String statusText = '';
                          Color badgeColor = Colors.transparent;
                          Color badgeTextColor = AppThemeColors.textSecondaryColor;

                          if (isToday) {
                            borderColor = AppThemeColors.primaryColor;
                          }

                          if (isPresent) {
                            bgColor = Colors.green.withOpacity(0.08);
                            badgeColor = Colors.green.withOpacity(0.18);
                            badgeTextColor = Colors.green;
                            statusText = dayInfo?.punch?.duration ?? 'Present';
                          } else if (isLeave) {
                            bgColor = Colors.orange.withOpacity(0.08);
                            badgeColor = Colors.orange.withOpacity(0.18);
                            badgeTextColor = Colors.orange;
                            statusText = 'Leave';
                          } else if (isHoliday) {
                            bgColor = Colors.blue.withOpacity(0.08);
                            badgeColor = Colors.blue.withOpacity(0.18);
                            badgeTextColor = Colors.blue;
                            statusText = dayInfo?.holidayName ?? 'Holiday';
                          } else if (isWeekend) {
                            bgColor = AppThemeColors.scaffoldBackgroundColor;
                            statusText = 'Off';
                            badgeTextColor = AppThemeColors.muted;
                          } else if (isAbsent) {
                            bgColor = Colors.red.withOpacity(0.08);
                            badgeColor = Colors.red.withOpacity(0.18);
                            badgeTextColor = Colors.red;
                            statusText = 'Absent';
                          }

                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isToday ? AppThemeColors.primaryColor : borderColor,
                                width: isToday ? 1.5 : 0.6,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '$day',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                                        color: isToday
                                            ? AppThemeColors.primaryColor
                                            : isWeekend
                                                ? AppThemeColors.muted
                                                : AppThemeColors.textPrimaryColor,
                                      ),
                                    ),
                                    if (isToday)
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: AppThemeColors.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                if (statusText.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(vertical: 1),
                                    decoration: BoxDecoration(
                                      color: badgeColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 8.5,
                                        fontWeight: FontWeight.w700,
                                        color: badgeTextColor,
                                      ),
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatChip(String title, String count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2), width: 0.8),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 12, color: color),
                const SizedBox(width: 4),
                Text(
                  title,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              count,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

