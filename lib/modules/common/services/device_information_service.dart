// lib/services/device_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceInformation() async {
    try {
      // 🌐 WEB
      if (kIsWeb) {
        final web = await _deviceInfo.webBrowserInfo;

        final String uniqueId =
            '${web.vendor ?? 'web'}_${web.userAgent?.hashCode ?? DateTime.now().millisecondsSinceEpoch}';

        return {
          'os': 'Web',
          'browserName': web.browserName.name,
          'appVersion': web.appVersion ?? '',
          'userAgent': web.userAgent ?? '',
          'platform': web.platform ?? '',
          'vendor': web.vendor ?? '',
          'language': web.language ?? '',
          'isPhysicalDevice': false,
          'uniqueId': uniqueId,
        };
      }

      // 📱 ANDROID
      final android = await _deviceInfo.androidInfo;
      final uniqueId = android.id?.isNotEmpty == true
          ? android.id!
          : android.fingerprint ?? 'android_unknown';

      return {
        'os': 'Android',
        'version': android.version.release ?? 'unknown',
        'sdkInt': android.version.sdkInt,
        'model': android.model ?? '',
        'brand': android.brand ?? '',
        'manufacturer': android.manufacturer ?? '',
        'isPhysicalDevice': android.isPhysicalDevice,
        'androidId': android.id ?? '',
        'fingerprint': android.fingerprint ?? '',
        'uniqueId': uniqueId,
      };
    } catch (e) {
      return {
        'os': 'Error',
        'error': e.toString(),
        'uniqueId': 'unknown_error_id',
      };
    }
  }
}
