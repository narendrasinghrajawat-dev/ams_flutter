import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get themeMode => _loadFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadFromBox() => _box.read(_key) ?? false;

  void saveToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.light().textTheme),
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
  );

  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    textTheme: GoogleFonts.openSansTextTheme(ThemeData.dark().textTheme),
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
  );

  void switchTheme() {
    final isDark = _loadFromBox();
    saveToBox(!isDark);
    Get.changeThemeMode(isDark ? ThemeMode.light : ThemeMode.dark);
  }
}
