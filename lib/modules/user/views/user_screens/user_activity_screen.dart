import 'package:attedance_management_system/modules/user/controller/user_activity_controller.dart';
import 'package:attedance_management_system/widgets/card/common_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_theme_colors.dart';
import '../../../../../data/utils/app_helper.dart';
import '../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class UserActivityScreen extends StatefulWidget {
  const UserActivityScreen({Key? key}) : super(key: key);

  @override
  State<UserActivityScreen> createState() => _UserActivityScreenState();
}

class _UserActivityScreenState extends State<UserActivityScreen> {

  // Initialize controller in the state class
  final UserActivityController _userActivityController = Get.find<UserActivityController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Card Wrapper

          Expanded(
            child: Obx(() {
                final activities = _userActivityController.filteredAttendanceActivitiesList;

                if (activities.isEmpty) {
                  return Center(
                    child: AppTextWidget.small("Activity Not Found"),
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isWideScreen = constraints.maxWidth >= 700;

                    // 📱 Mobile → ListView (1 per row)
                    if (!isWideScreen) {
                      return ListView.separated(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                        itemCount: activities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, idx) {
                          final activity = activities[idx];

                          final bool isCheckIn = activity.punchType == "1";

                          final String formattedTime =
                          activity.punchTime != null
                              ? AppHelper.formatTimeString(activity.punchTime!)
                              : 'N/A';

                          final String formattedDate =
                          activity.punchDate != null
                              ? AppHelper.formatDateString(activity.punchDate!)
                              : 'N/A';

                          return _buildActivityTile(
                            time: formattedTime,
                            date: formattedDate,
                            isCheckIn: isCheckIn,
                          );
                        },
                      );
                    }

                    // 🌐 Web / Desktop → GridView (2 per row)
                    return GridView.builder(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      itemCount: activities.length,
                      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,          // 👈 2 tiles per row
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isWideScreen ? 10 : 3.8,      // 👈 adjust based on tile height
                      ),
                      itemBuilder: (_, idx) {
                        final activity = activities[idx];

                        final bool isCheckIn = activity.punchType == "1";

                        final String formattedTime =
                        activity.punchTime != null
                            ? AppHelper.formatTimeString(activity.punchTime!)
                            : 'N/A';

                        final String formattedDate =
                        activity.punchDate != null
                            ? AppHelper.formatDateString(activity.punchDate!)
                            : 'N/A';

                        return _buildActivityTile(
                          time: formattedTime,
                          date: formattedDate,
                          isCheckIn: isCheckIn,
                        );
                      },
                    );
                  },
                );
              },
            ),
          )

        ],
      ),
    );
  }

  // NOTE: Removed 'type' from required parameters as it's not used in the UI logic now
  Widget _buildActivityTile({required String time, required String date, required bool isCheckIn,}) {
    final Color color =
    isCheckIn ? AppThemeColors.successColor : AppThemeColors.errorColor;

    final IconData icon =
    isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

    return CommonCardWidget(
      child: Row(
        children: [
          // Icon Circle
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextWidget.small(
                  isCheckIn ? "Check In" : "Check Out",
                  color: AppThemeColors.textPrimaryColor,
                ),
                const SizedBox(height: 4),
                AppTextWidget.verySmall(
                  date, // Display formatted date
                  color: AppThemeColors.muted,
                ),
              ],
            ),
          ),
          // Time
          AppTextWidget.medium(
            time, // Display formatted time
            color: AppThemeColors.textPrimaryColor,
          )
        ],
      ),
    );
  }
}