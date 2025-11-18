import 'package:attedance_management_system/routes/app_pages.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/app_binding.dart';
import 'core/localization/translation.dart';
import 'core/theme/theme_service.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AMS',
      initialBinding: AppBinding(),
      translations: TranslationService(),
      locale: TranslationService.locale,
      fallbackLocale: TranslationService.fallbackLocale,
      theme: _themeService.lightTheme,
      darkTheme: _themeService.darkTheme,
      themeMode: _themeService.themeMode,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.login,
      debugShowCheckedModeBanner: false,
    );
  }
}
