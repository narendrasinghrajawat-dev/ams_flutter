// lib/services/device_service.dart
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static Future<Map<String, dynamic>> getDeviceInformation() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo a = await _deviceInfo.androidInfo;
        return {
          'os': 'Android',
          'version': a.version.release ?? 'unknown',
          'sdkInt': a.version.sdkInt ?? 0,
          'model': a.model ?? '',
          'brand': a.brand ?? '',
          'device': a.device ?? '',
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo i = await _deviceInfo.iosInfo;
        return {
          'os': 'iOS',
          'systemName': i.systemName ?? 'iOS',
          'systemVersion': i.systemVersion ?? 'unknown',
          'model': i.model ?? '',
        };
      } else {
        return {'os': Platform.operatingSystem, 'version': 'N/A'};
      }
    } catch (e) {
      // Very likely a MissingPluginException if plugin not registered.
      return {'os': 'Error', 'version': 'N/A', 'error': e.toString()};
    }
  }
}
