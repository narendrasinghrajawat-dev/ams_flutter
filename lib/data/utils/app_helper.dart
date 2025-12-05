import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../../core/constants/app_theme_colors.dart';
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

  static String formatDateString(String? inputDate, {String convertType = '.'}) {

    if (AppHelper.isEmptyOrNull(inputDate)) {
      return "";
    }

    DateTime? dateTime;

    // First, try parsing with DateTime.tryParse (handles ISO 8601 and some common formats)
    dateTime = DateTime.tryParse(inputDate!);
    if (dateTime != null) {
      final DateFormat formatter = DateFormat('dd${convertType}MM${convertType}yyyy');
      return formatter.format(dateTime);
    }

    // Define specific formats to try, ordered from most common to less common/specific
    final List<String> formatsToTry = [
      "MM/dd/yyyy", // This is the format for "9/24/2024"
      "M/d/yyyy",   // For single digit month/day like "9/1/2024"
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", // ISO 8601 with microseconds and Z
      "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",   // ISO 8601 with microseconds
      "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",   // ISO 8601 with milliseconds and Z
      "yyyy-MM-dd'T'HH:mm:ss.SSS",      // ISO 8601 with milliseconds
      "yyyy-MM-dd'T'HH:mm:ss'Z'",       // ISO 8601 without fractional seconds and Z
      "yyyy-MM-dd'T'HH:mm:ss",          // ISO 8601 without fractional seconds
      "yyyy-MM-dd HH:mm:ss.SSS",        // Common without 'T' with milliseconds
      "yyyy-MM-dd HH:mm:ss",            // Common without 'T'
      "yyyy-MM-dd",                     // Date only

      // Common date formats
      "dd-MM-yyyy HH:mm:ss",
      "dd-MM-yyyy",
      "MM-dd-yyyy HH:mm:ss",
      "MM-dd-yyyy",
      "dd/MM/yyyy HH:mm:ss",
      "dd/MM/yyyy",
      // "MM/dd/yyyy HH:mm:ss", // Already handled above or by M/d/yyyy variants
      // "MM/dd/yyyy",          // Already handled above or by M/d/yyyy variants

      "MMM dd, yyyy",                   // e.g., Jan 01, 2024
      "MMMM dd, yyyy",                  // e.g., January 01, 2024
      "dd MMM yyyy",                    // e.g., 01 Jan 2024
      "dd MMMM yyyy",                   // e.g., 01 January 2024
      "E, MMM dd yyyy HH:mm:ss z",      // RFC 1123 / RFC 822 format (e.g., Thu, 01 Jan 1970 00:00:00 GMT)
      "EEEE, MMMM d, yyyy h:mm a",      // e.g., Monday, January 1, 2024 1:00 PM
    ];

    for (String format in formatsToTry) {
      try {
        dateTime = DateFormat(format).parseStrict(inputDate);
        break; // Successfully parsed, exit loop
      } catch (e) {
        if (kDebugMode) {
          // print("Trying format '$format' failed for '$inputDate': $e"); // For more detailed debugging
        }
      }
    }
    if (dateTime == null) {
      print("Warning: Could not parse date string: $inputDate");
      return ""; // Or throw an exception, or return a default error message
    }

    // Format the DateTime object to the desired output format
    final DateFormat formatter = DateFormat('dd${convertType}MM${convertType}yyyy');
    return formatter.format(dateTime);
  }


  static String formateTimeString(String? inputDate) {
    if (AppHelper.isEmptyOrNull(inputDate)) {
      return "";
    }

    DateTime dateTime = DateTime.parse(inputDate!);

    // Format the time to HH:mm
    return DateFormat('HH:mm').format(dateTime);
  }


  // Helper function to get month abbreviation (optional, can use Intl package too)
  static String _getMonthAbbreviation(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return monthNames[month - 1];
  }


  static Color getLeavesStatusColor(String? s) {

    if(s == null || s.isEmpty){
      return AppThemeColors.warningColor;
    }

    final lower = s.toLowerCase();
    if (lower == AppStrings.approvedStatusKey) return AppThemeColors.successColor;
    if (lower == AppStrings.pendingStatusKey) return AppThemeColors.warningColor;
    if (lower == AppStrings.rejectedStatusKey) {
      return AppThemeColors.errorColor;
    }
    return AppThemeColors.muted;
  }


}

