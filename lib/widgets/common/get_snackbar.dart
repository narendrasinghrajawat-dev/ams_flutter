


import 'package:attedance_management_system/core/constants/app_theme_colors.dart';
import 'package:attedance_management_system/widgets/text_and_icon_widgets/app_text_type.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enum for standardizing snackbar types (Success, Error, Warning)
enum SnackbarType { success, error, warning, info }

class UIHelper {

  /**
   * Shows a standardized GetX Snackbar with dynamic content and styling.
   * * @param title The main title of the notification (e.g., 'Success').
   * @param message The detailed message (e.g., 'Attendance punched successfully').
   * @param type Determines the icon and background color.
   * @param duration How long the snackbar remains visible.
   */
  static void showSnackbar(String title, String message, {SnackbarType type = SnackbarType.info, Duration duration = const Duration(seconds: 3), SnackPosition snackPosition = SnackPosition.BOTTOM,}) {
    Color backgroundColor;
    IconData icon;
    SnackPosition snackPos = snackPosition;

    // Determine color and icon based on the message type
    switch (type) {
      case SnackbarType.success:
        backgroundColor = AppThemeColors.snackBarSuccessColor;
        icon = Icons.check_circle_outline;
        break;
      case SnackbarType.error:
        backgroundColor = AppThemeColors.snackBarErrorColor;
        icon = Icons.error_outline;
        break;
      case SnackbarType.warning:
        backgroundColor = AppThemeColors.snackBarWarningColor;
        icon = Icons.warning_amber_outlined;
        break;
      case SnackbarType.info:
      default:
        backgroundColor = AppThemeColors.snackBarInfoColor;
        icon = Icons.info_outline;
        break;
    }

    // Call the Get.snackbar method
    Get.snackbar(
      title,
      message,
      titleText: AppTextWidget.large(title, color: AppThemeColors.whiteColor,),
      messageText: AppTextWidget.medium(message, color: AppThemeColors.whiteColor,),
      icon: Icon(icon, color: Colors.white, size: 28),
      snackPosition: snackPos, // Use a consistent position
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 8.0,
      duration: duration,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
    );
  }

  // --- Convenience Functions (Optional but Recommended) ---

  static void showSuccess(String message, {String title = 'Success'}) {
    showSnackbar(title, message, type: SnackbarType.success);
  }

  static void showError(String message, {String title = 'Error'}) {
    showSnackbar(title, message, type: SnackbarType.error, duration: const Duration(seconds: 5));
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    showSnackbar(title, message, type: SnackbarType.warning);
  }
}