import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../enums/app_environment.dart';

/// Define which environment app is running in.

/// Set environment before runApp()
class EnvConfig {
  static AppEnvironment _env = AppEnvironment.production;

  static AppEnvironment get env => _env;

  static void setEnvironment(AppEnvironment env) {
    _env = env;
  }

  static bool get isProd => _env == AppEnvironment.production;
  static bool get isStaging => _env == AppEnvironment.test;
  static bool get isDev => _env == AppEnvironment.development;
}

/// Handles LIGHT / DARK and PROD / TEST / DEV color variations.
/// Clean naming like scaffoldBackgroundColor, textPrimaryColor, primaryDarkColor, etc.
class AppThemeColors {
  static bool get isDark => Get.isDarkMode;

  // ============================================================
  // ENVIRONMENT-BASED PRIMARY COLORS
  // ============================================================

  static Color get primaryColor {
    if (EnvConfig.isProd) return const Color(0xFF1E88E5); // Blue
    if (EnvConfig.isStaging) return const Color(0xFF1565C0); // Darker Blue
    return const Color(0xFF42A5F5); // Dev/Test - Lighter Blue
  }

  static Color get primaryDarkColor {
    if (EnvConfig.isProd) return const Color(0xFF002171);
    if (EnvConfig.isStaging) return const Color(0xFF0B3A87);
    return const Color(0xFF0059B2);
  }

  static Color get primaryLightColor {
    if (EnvConfig.isProd) return const Color(0xFFBBDEFB);
    if (EnvConfig.isStaging) return const Color(0xFF90CAF9);
    return const Color(0xFFE3F2FD);
  }

  // ============================================================
  // BACKGROUND COLORS
  // ============================================================

  static Color get scaffoldBackgroundColor => isDark ? const Color(0xFF0D0D0D) : const Color(0xFFFFFFFF);

  static Color get cardBackgroundColor => isDark ? const Color(0xFF1C1C1C) : const Color(0xFFFFFFFF);

  static Color get containerBackgroundColor => isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5);

  // ============================================================
  // APPBAR
  // ============================================================

  static Color get appBarColor => isDark ? const Color(0xFF101010) : const Color(0xFFFFFFFF);

  static Color get appBarTextColor => isDark ? Colors.white : Colors.black87;

  // ============================================================
  // BUTTON COLORS
  // ============================================================

  static Color get buttonColor => primaryColor;

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
  // ICON COLORS
  // ============================================================

  static Color get iconColor => isDark ? Colors.white70 : Colors.black54;

  static Color get iconActiveColor => primaryColor;

  // ============================================================
  // DIVIDER / BORDER COLORS
  // ============================================================

  static Color get dividerColor => isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

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



  static Color get muted =>
      isDark ? const Color(0xFFB0BEC5) : const Color(0xFF90A4AE);


}
