import 'dart:io';

import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/constants/app_theme_colors.dart';
import 'core/enums/app_environment.dart';
import 'modules/common/controller/loading_controller.dart';
import 'modules/common/controller/settings_controller.dart';
import 'modules/common/utils/http_override_web.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Set environment dynamically using --dart-define
  const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  AppEnvironment environment;
  if (appEnv == 'prod') {
    environment = AppEnvironment.production;
  } else if (appEnv == 'test') {
    environment = AppEnvironment.test;
  } else {
    environment = AppEnvironment.development;
  }
  EnvConfig.setEnvironment(environment);

  await dotenv.load(
    fileName: environment == AppEnvironment.development
        ? 'env/.env.dev'
        : environment == AppEnvironment.test
        ? 'env/.env.test'
        : 'env/.env.prod',
  );

  await GetStorage.init();

  Get.put<LoadingController>(LoadingController(), permanent: true);
  Get.put<SettingsController>(SettingsController(), permanent: true);
  setupHttpOverrides(); // ✅ works on both mobile and web now

  runApp(App());
}

