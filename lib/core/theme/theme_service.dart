import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_theme_colors.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get themeMode => _loadFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadFromBox() => _box.read(_key) ?? false;

  void saveToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme),
    primaryColor: AppThemeColors.primaryColor,
    scaffoldBackgroundColor: const Color(0xFFF8FAFC),
    cardColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: AppThemeColors.primaryColor,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.openSans(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
    primaryColor: AppThemeColors.primaryColor,
    scaffoldBackgroundColor: const Color(0xFF0F172A),
    cardColor: const Color(0xFF1E293B),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E293B),
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: GoogleFonts.openSans(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  void switchTheme() {
    final isDark = _loadFromBox();
    saveToBox(!isDark);
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
