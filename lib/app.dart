import 'package:attedance_management_system/routes/app_pages.dart';
import 'package:attedance_management_system/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'modules/common/controller/loading_controller.dart';
import 'core/bindings/app_binding.dart';
import 'core/localization/translation.dart';
import 'core/theme/theme_service.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {

    final loading = Get.find<LoadingController>();

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
      initialRoute: AppRoutes.splashScreen,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Stack(
          children: [
            child ?? const SizedBox.shrink(),

            // Global loader overlay (hidden on splash screen)
            Obx(() {
              // ALWAYS read the Rx value so Obx can track it
              final bool isLoading = loading.isLoading.value;
              final String currentRoute = Get.currentRoute;
              final bool isSplash = currentRoute == AppRoutes.splashScreen;

              print('app loaidnd id dh$isLoading');

              if (isSplash || !isLoading) {
                return const SizedBox.shrink();
              }

              return Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}
