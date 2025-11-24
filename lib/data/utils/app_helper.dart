import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/common/storage_service.dart';

class AppHelper {

  static StorageService storageService = StorageService();

  static bool isEmptyOrNull(dynamic value) {
    if (value == null) {
      return true;
    }
    if (value is String) {
      return value.trim().isEmpty;
    }
    if (value is Map) {
      return value.isEmpty;
    }

    if (value is Iterable) {
      return value.isEmpty;
    }
    return false;
  }

  static User getProfileUser(){
    return User.fromJson(storageService.readMap(AppStrings.profileJson)!);
  }


  /// Converts a string like "TimeOfDay(18:52)" into a displayable time "06:52 PM".

  /// Converts a string like "TimeOfDay(18:52)" into a displayable time "06:52 PM".
  static String formatTimeString(String punchTime, BuildContext context) {
    // Expected format: "TimeOfDay(HH:mm)"
    try {
      // 1. Extract the time string "18:52"
      final timeString = punchTime.replaceAll('TimeOfDay(', '').replaceAll(')', '').trim();
      final parts = timeString.split(':');

      if (parts.length != 2) return punchTime;

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // 2. Create the TimeOfDay object
      final timeOfDay = TimeOfDay(hour: hour, minute: minute);

      // 3. Use the format() method with BuildContext to get the localized time string
      // This is what converts 18:52 to 6:52 PM (or 18:52 depending on locale settings)
      return timeOfDay.format(context);

    } catch (e) {
      // Log or handle error if parsing fails
      debugPrint('Error formatting punch time: $e, Input: $punchTime');
      return 'Invalid Time';
    }
  }

// --- How to use it in your Widget ---
//
// @override
// Widget build(BuildContext context) {
//   // ... in your itemBuilder
//   return _buildActivityTile(
//     time: formatTimeString(activity.punchTime!, context), // Pass context here
//     // ... other fields
//   );
// }

  /// Converts a string like "2025-11-24T18:52:45.472178" into a displayable date "Nov 24, 2025".
  static String formatDateString(String punchDate) {
    // Expected format: "yyyy-MM-ddTHH:mm:ss.sss"
    try {
      final dateTime = DateTime.parse(punchDate);

      // Simple format: "Month Day, Year"
      return '${_getMonthAbbreviation(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
    } on FormatException catch (e) {
      // Log or handle error if parsing fails
      debugPrint('Error formatting punch date: $e, Input: $punchDate');
      return 'Invalid Date';
    }
  }

  // Helper function to get month abbreviation (optional, can use Intl package too)
  static String _getMonthAbbreviation(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }
}

