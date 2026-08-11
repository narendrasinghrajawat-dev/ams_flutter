import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../enums/app_environment.dart';
import '../../modules/common/controller/settings_controller.dart';




class EnvConfig {
  static AppEnvironment _env = AppEnvironment.production;

  static AppEnvironment get env => _env;

  static void setEnvironment(AppEnvironment env) {
    _env = env;
  }

  static AppEnvironment getEnvironment() {
   return _env;
  }


  static bool get isProd => _env == AppEnvironment.production;
  static bool get isTest => _env == AppEnvironment.test;
  static bool get isDev => _env == AppEnvironment.development;
}



class AppThemeColors {
  static bool get isDark {
    try {
      if (Get.isRegistered<SettingsController>()) {
        return Get.find<SettingsController>().isDark.value;
      }
    } catch (_) {}
    return Get.isDarkMode;
  }


  static const Color primaryProdColor = Color(0xFF009688);
  static const Color primaryTestColor = Color(0xFF009688);
  static const Color primaryDevColor = Color(0xFF009688);


  static const Color primaryLightProdColor = Color(0xFF009688);
  static const Color primaryLightTestColor = Color(0xFF009688);
  static const Color primaryLightDevColor = Color(0xFF009688);



  static const Color primaryDarkProdColor = Color(0xFF002171);
  static const Color primaryDarkTestColor = Color(0xFF002171);
  static const Color primaryDarkDevColor = Color(0xFF002171);

  // ============================================================
  // ENVIRONMENT-BASED PRIMARY COLORS
  // ============================================================

  static Color get primaryColor => primaryProdColor;

  static Color get primaryDarkColor => primaryDarkProdColor;

  static Color get primaryLightColor => primaryLightProdColor;




  // dependent colors on primary colors list

  static Color get scaffoldBackgroundColor => isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);

  static Color get appbarBackgroundColor => isDark ? const Color(0xFF1E293B) : primaryColor;

  static Color get buttonBgColor => primaryColor;

  static Color get loaderColor => isDark ? Colors.white : primaryColor;

  static Color get containerBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;

  // ============================================================
  // APPBAR
  // ============================================================

  static Color get appBarColor => isDark ? const Color(0xFF1E293B) : primaryColor;

  static Color get appBarTextColor => Colors.white;

  // ============================================================
  // BUTTON COLORS
  // ============================================================

  static Color get buttonTextColor => Colors.white;

  static Color get buttonDisabledColor => isDark ? Colors.white24 : Colors.black12;

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static Color get textPrimaryColor => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

  static Color get textSecondaryColor => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  static Color get textHintColor => isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);

  static Color get textDisabledColor => isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

  static Color get textLargeColor => isDark ? const Color(0xFFF8FAFC) : const Color(0xFF0F172A);

  static Color get textMediumColor => isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);

  static Color get textSmallColor => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  // ============================================================
  // CARD COLORS
  // ============================================================
  static Color get dashboardCardBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;

  static Color get cardBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;

  static Color get cardBorderColor => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  // ============================================================
  // Container COLORS
  // ============================================================
  static Color get containerBgColor => isDark ? const Color(0xFF1E293B) : Colors.white;

  // Circle Avatar Colors
  static Color get circleAvatarBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;

  // ============================================================
  // ICON COLORS
  // ============================================================

  static Color get iconColor => isDark ? const Color(0xFF94A3B8) : primaryColor;

  static Color get iconActiveColor => primaryColor;

  // ============================================================
  // DIVIDER / BORDER COLORS
  // ============================================================

  static Color get dividerColor => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  static Color get borderColor => isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

  // ============================================================
  // STATUS COLORS (SUCCESS / ERROR / WARNING)
  // ============================================================

  static const Color successColor = Color(0xFF10B981);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);

  // ============================================================
  // WALKTHROUGH / DOTS COLORS
  // ============================================================

  static const Color dotsColor = Color(0xFFDADADA);
  static const Color dotsActiveColor = Color(0xFFFF8080);

  // ============================================================
  // RICH TEXT COLOR
  // ============================================================

  static Color get richTextColor => primaryColor;

  static Color get muted => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  // Form Colors
  static Color get suffixIconColor => isDark ? const Color(0xFF81D4FA) : const Color(0xFF1565C0);
  static Color get prefixIconColor => isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
  static Color get focusBorderColor => primaryColor;
  static Color get errorBorderColor => errorColor;
  static Color get disableBorderColor => isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);
  static Color get disableLabelColor => isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8);
  static Color get enableBorderColor => isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1);

  static Color get datePickerBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;
  static Color get dropDownBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;
  static Color get sliderActiveColor => primaryColor;
  static Color get sliderInActiveColor => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
  static Color get inactiveTrackColor => isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  static List<Color> get splashGradientColors => isDark ? [const Color(0xFF0F172A), const Color(0xFF1E293B)] : [primaryColor, primaryColor];

  static Color get splashIconBg => isDark ? Colors.white12 : Colors.black12;
  static Color get splashTextColor => Colors.white;
  static Color get splashProgressColor => Colors.white;
  static Color get whiteColor => Colors.white;

  // Other common widgets
  static Color get popupBackgroundColor => isDark ? const Color(0xFF1E293B) : Colors.white;
  static Color get editIconColors => primaryColor;
  static Color get deleteIconColor => errorColor;

  // SnackBar Color
  static Color get snackBarSuccessColor => successColor;
  static Color get snackBarErrorColor => errorColor;
  static Color get snackBarWarningColor => warningColor;
  static Color get snackBarInfoColor => primaryColor;

  static Color get collapsedBackgroundColor => isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
  static Color get collapsedIconColor => isDark ? const Color(0xFF94A3B8) : primaryColor;

  // Punch Type Colors
  static Color get checkInColor => successColor;
  static Color get checkOutColor => errorColor;

  static const Color totalColor = Color(0xFF6366F1);
  static const Color availableColor = Color(0xFF10B981);
  static const Color usedColor = Color(0xFFEF4444);

}
