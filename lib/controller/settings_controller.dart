import 'package:get/get.dart';
import '../../core/theme/theme_service.dart';

class SettingsController extends GetxController {
  final ThemeService _themeService = ThemeService();

  void toggleTheme() => _themeService.switchTheme();
}
