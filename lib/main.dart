import 'package:attedance_management_system/core/constants/const_strings.dart';
import 'package:attedance_management_system/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/constants/app_theme_colors.dart';
import 'core/enums/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.setEnvironment(AppEnvironment.development);
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: AppStrings.dev);
  await dotenv.load(
    fileName: environment ==  AppStrings.dev ? 'env/.env.dev' : environment == AppStrings.test ? 'env/.env.test' : 'env/.env.prod',
  );


  await GetStorage.init();

  runApp(App());
}
