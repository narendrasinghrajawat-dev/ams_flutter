import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'core/constants/app_theme_colors.dart';
import 'core/enums/app_environment.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.setEnvironment(AppEnvironment.development);
  String environmentName = EnvConfig.getEnvironment().name;
  var environment = String.fromEnvironment('ENVIRONMENT', defaultValue: environmentName);
  await dotenv.load(
    fileName: environment == AppEnvironment.development.name ? 'env/.env.dev' : environment == AppEnvironment.test.name ? 'env/.env.test' : 'env/.env.prod',
  );

  await GetStorage.init();
  runApp(App());
}
