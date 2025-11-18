import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'core/constants/app_theme_colors.dart';
import 'core/enums/app_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.setEnvironment(AppEnvironment.development);
  await GetStorage.init();
  runApp(App());
}
