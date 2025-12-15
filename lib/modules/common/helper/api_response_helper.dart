
import 'package:flutter/material.dart';
import '../../../core/constants/app_theme_colors.dart';
import '../../../widgets/common/ui_helper_widgets.dart';

class ApiResponseHelper {
  static void showSnackbarByStatus({
    required int status,
    String? message,
  }) {
    late String title;
    late Color bgColor;

    switch (status) {
      case 400:
        title = 'Bad Request';
        bgColor = AppThemeColors.errorColor;
        break;

      case 401:
        title = 'Unauthorized';
        bgColor = AppThemeColors.errorColor;
        break;

      case 403:
        title = 'Forbidden';
        bgColor = AppThemeColors.warningColor;
        break;

      case 404:
        title = 'Not Found';
        bgColor = AppThemeColors.warningColor;
        break;

      case 500:
        title = 'Server Error';
        bgColor = AppThemeColors.errorColor;
        break;

      default:
        title = 'Error';
        bgColor = AppThemeColors.errorColor;
    }

    UIHelper.showSnackbar(
      title,
      message ?? 'Something went wrong',
      type: SnackbarType.error,
    );
  }
}
