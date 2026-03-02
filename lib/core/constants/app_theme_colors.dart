import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../enums/app_environment.dart';




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
  static bool get isDark => Get.isDarkMode;


  static const Color primaryProdColor = Color(0xFF009688);
  static const Color primaryTestColor = Color(0xFF7E57C2);
  static const Color primaryDevColor = Color(0xFF42A5F5);


  static const Color primaryLightProdColor = Color(0xFF009688);
  static const Color primaryLightTestColor = Color(0xFF7E57C2);
  static const Color primaryLightDevColor = Color(0xFF42A5F5);



  static const Color primaryDarkProdColor = Color(0xFF002171);
  static const Color primaryDarkTestColor = Color(0xFF0B3A87);
  static const Color primaryDarkDevColor = Color(0xFF141414);

  // ============================================================
  // ENVIRONMENT-BASED PRIMARY COLORS
  // ============================================================

  static Color get primaryColor {
    if (EnvConfig.isProd) return primaryProdColor; // Blue
    if (EnvConfig.isTest) return primaryTestColor; // Darker Blue
    return primaryDevColor; // Dev/Test - Lighter Blue
  }

  static Color get primaryDarkColor {
    if (EnvConfig.isProd) return primaryDarkProdColor;
    if (EnvConfig.isTest) return primaryDarkTestColor;
    return primaryDarkDevColor;
  }

  static Color get primaryLightColor {
    if (EnvConfig.isProd) return primaryLightProdColor;
    if (EnvConfig.isTest) return primaryLightTestColor;
    return primaryLightDevColor;
  }




  // dependent colors on primary colors list

  static Color get scaffoldBackgroundColor => isDark ? primaryDarkColor : primaryLightColor;

  static Color get appbarBackgroundColor => isDark ? primaryDarkColor : primaryLightColor;

  static Color get buttonBgColor => isDark ? primaryDarkColor : primaryLightColor;

  static Color get loaderColor => isDark ? Colors.white : primaryLightColor;

  static Color get containerBackgroundColor => isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  // ============================================================
  // APPBAR
  // ============================================================

  static Color get appBarColor => isDark ? const Color(0xFF101010) : const Color(0xFFFFFFFF);

  static Color get appBarTextColor => isDark ? Colors.white : Colors.black87;

  // ============================================================
  // BUTTON COLORS
  // ============================================================


  static Color get buttonTextColor => isDark ? Colors.white : Colors.white;

  static Color get buttonDisabledColor => isDark ? Colors.white24 : Colors.black12;

  // ============================================================
  // TEXT COLORS
  // ============================================================

  static Color get textPrimaryColor => isDark ? Colors.white : const Color(0xFF263238);

  static Color get textSecondaryColor => isDark ? Colors.white70 : const Color(0xFF546E7A);

  static Color get textHintColor => isDark ? Colors.white38 : const Color(0xFF90CAF9);

  static Color get textDisabledColor => isDark ? Colors.white24 : const Color(0xFFBDBDBD);

  static Color get textLargeColor => isDark ? Colors.white : const Color(0xFF000000);

  static Color get textMediumColor => isDark ? Colors.white70 : const Color(0xDD000000);

  static Color get textSmallColor => isDark ? Colors.white54 : const Color(0x8A000000);

  // ============================================================
  // CARD COLORS
  // ============================================================
  static Color get dashboardCardBackgroundColor => isDark ? primaryDarkColor : primaryLightColor.withOpacity(.15);

  static Color get cardBackgroundColor => isDark ? primaryDarkColor : primaryLightColor.withOpacity(.03);

  static Color get cardBorderColor => isDark ? primaryDarkColor : primaryLightColor.withOpacity(.2);

  // ============================================================
  // Container COLORS
  // ============================================================
  static Color get containerBgColor => isDark ? Colors.white70 : Colors.white70;

  // Circle Avatar Colors
  static Color get circleAvatarBackgroundColor => isDark ? Colors.white : Colors.white;

  // ============================================================
  // ICON COLORS
  // ============================================================

  static Color get iconColor => isDark ? primaryLightColor : primaryLightColor;

  static Color get iconActiveColor => primaryColor;

  // ============================================================
  // DIVIDER / BORDER COLORS
  // ============================================================

  static Color get dividerColor => isDark ? primaryLightColor.withOpacity(.1) : primaryLightColor;

  static Color get borderColor => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFBDBDBD);

  // ============================================================
  // STATUS COLORS (SUCCESS / ERROR / WARNING)
  // ============================================================

  static const Color successColor = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFF9A825);

  // ============================================================
  // WALKTHROUGH / DOTS COLORS
  // ============================================================

  static const Color dotsColor = Color(0xFFDADADA);
  static const Color dotsActiveColor = Color(0xFFFF8080);

  // ============================================================
  // RICH TEXT COLOR
  // ============================================================

  static Color get richTextColor => primaryColor;



  static Color get muted => isDark ? const Color(0xFFB0BEC5) : const Color(0xFF90A4AE);


  // Form Colors

  /// Color for icons inside the suffix position (often focus color).
  static Color get suffixIconColor => Get.isDarkMode ? const Color(0xFF81D4FA) : const Color(0xFF1565C0);
  /// Color for icons inside the prefix position (more subtle).
  static Color get prefixIconColor => Get.isDarkMode ? const Color(0xFFB0BEC5) : const Color(0xFF90A4AE);
  /// Color for the border when the field is enabled but not focused.
  // static Color get enableBorderColor => Get.isDarkMode ? const Color(0xFF455A64) : const Color(0xFFCFD8DC);
  /// Color for the border when the field is actively focused.
  static Color get focusBorderColor => Get.isDarkMode ? const Color(0xFF42A5F5) : const Color(0xFF1976D2);
  /// Color for the border when a validation error occurs.
  static Color get errorBorderColor => Get.isDarkMode ? const Color(0xFFEF5350) : const Color(0xFFD32F2F);
  /// Color for the border when the field is explicitly disabled.
  static Color get disableBorderColor => Get.isDarkMode ? const Color(0xFF616161) : const Color(0xFFBDBDBD);
  /// Color for the label/hint text when the field is disabled.
  static Color get disableLabelColor => Get.isDarkMode ? const Color(0xFF757575) : const Color(0xFF9E9E9E);
  static Color get enableBorderColor => isDark ? primaryLightColor : primaryDarkColor;


  static Color get datePickerBackgroundColor => Get.isDarkMode ? const Color(0xFF757575) :  Color(0xFFFFFFFF);
  static Color get dropDownBackgroundColor => Get.isDarkMode ? const Color(0xFF757575) :  Color(0xFFFFFFFF);
  static Color get sliderActiveColor => Get.isDarkMode ? const Color(0xFF757575) :  Color(0xFF1E88E5);
  static Color get sliderInActiveColor => Get.isDarkMode ? const Color(0xFF757575) :  Color(0xFFBBDEFB);
  static Color get inactiveTrackColor => Get.isDarkMode ? const Color(0xFF757575) :  Color(0xFFFFFFFF);


  static List<Color>  get splashGradientColors => Get.isDarkMode ? [primaryDarkColor, primaryDarkColor] : [primaryLightColor, primaryLightColor];

  // static List<Color> get splashGradientColors {
  //   if (EnvConfig.isDev) {
  //     return [Color(0xFF5E92F3), Color(0xFF42A5F5)]; // dev blue-ish
  //   }
  //   if (EnvConfig.isTest) {
  //     return [Color(0xFF6A1B9A), Color(0xFF8E24AA)]; // staging purple-ish
  //   }
  //
  //   if (EnvConfig.isProd) {
  //     return [Color(0xFF00ACC1), Color(0xFF4DD0E1)]; // staging purple-ish
  //   }
  //
  //   // production default (blue -> indigo)
  //   return isDark
  //       ? [Color(0xFF1A237E), Color(0xFF283593)]
  //       : [Color(0xFF1976D2), Color(0xFF42A5F5)];
  // }

  /// Splash icon background (circle behind icon)
  static Color get splashIconBg => isDark ? primaryLightColor.withOpacity(0.12) : primaryLightColor.withOpacity(0.25);

  /// Splash text color (usually white on gradient)
  static Color get splashTextColor => Colors.white;

  /// Progress bar color on splash
  static Color get splashProgressColor => Colors.white;

  static Color get whiteColor => Colors.white;



//   other common widgets
  static Color get popupBackgroundColor => isDark ? primaryDarkColor : Colors.white;

  static Color get editIconColors => isDark ? primaryDarkColor : primaryLightColor;

  static Color get deleteIconColor => isDark ? primaryDarkColor : Colors.red;



  // SnackBar Color
  static Color get snackBarSuccessColor => isDark ? Colors.green : Colors.green;
  static Color get snackBarErrorColor => isDark ? Colors.red : Colors.red;
  static Color get snackBarWarningColor => isDark ? Colors.yellow : Colors.orange;
  static Color get snackBarInfoColor => isDark ? Colors.green : Colors.green;

  static Color get collapsedBackgroundColor => isDark ? primaryDarkColor : primaryLightColor.withOpacity(.01);
  static Color get collapsedIconColor => isDark ? primaryLightColor : primaryDarkColor;


//   Punch Type Colors

  static Color get checkInColor => isDark ? primaryDarkColor : Colors.green;
  static Color get checkOutColor => isDark ? primaryDarkColor : Colors.red;



  static const Color totalColor = Color(0xFF6366F1);
  static const Color availableColor = Color(0xFF10B981);
  static const Color usedColor = Color(0xFFEF4444);

}
