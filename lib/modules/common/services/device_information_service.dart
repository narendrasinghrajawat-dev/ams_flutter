// lib/services/device_service.dart
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Fetches essential device identification and system information, including a stable unique ID.
  static Future<Map<String, dynamic>> getDeviceInformation() async {
    try {
      if (Platform.isAndroid) {
        final AndroidDeviceInfo a = await _deviceInfo.androidInfo;

        // Best effort to create a persistent ID on Android
        final String uniqueId = a.id != null && a.id!.isNotEmpty
            ? a.id! // a.id is often the ANDROID_ID
            : a.fingerprint ?? 'android_unknown_id';

        return {
          'os': 'Android',
          'version': a.version.release ?? 'unknown',
          'sdkInt': a.version.sdkInt,
          'model': a.model ?? '',
          'brand': a.brand ?? '',
          'manufacturer': a.manufacturer ?? '',
          'isPhysicalDevice': a.isPhysicalDevice,
          'androidId': a.id ?? '',               // <-- Added Android ID
          'fingerprint': a.fingerprint ?? '',    // <-- Added Fingerprint
          'uniqueId': uniqueId,                 // <-- CONSOLIDATED STABLE ID
        };
      } else if (Platform.isIOS) {
        final IosDeviceInfo i = await _deviceInfo.iosInfo;

        // identifierForVendor is the standard, persistent unique ID on iOS (resets if ALL vendor apps are deleted)
        final String uniqueId = i.identifierForVendor ?? 'ios_unknown_id';

        return {
          'os': 'iOS',
          'systemName': i.systemName ?? 'iOS',
          'systemVersion': i.systemVersion ?? 'unknown',
          'model': i.model ?? '',
          'modelName': i.modelName ?? '',
          'machineType': i.utsname.machine ?? '',
          'isPhysicalDevice': i.isPhysicalDevice,
          'identifierForVendor': i.identifierForVendor ?? '', // <-- Added Vendor ID
          'uniqueId': uniqueId,                               // <-- CONSOLIDATED STABLE ID
        };
      } else {
        // Fallback for Desktop/Fuchsia
        return {
          'os': Platform.operatingSystem,
          'version': 'N/A',
          'uniqueId': 'desktop_${Platform.operatingSystem}_id',
          'platform': Platform.operatingSystem
        };
      }
    } catch (e) {
      return {
        'os': 'Error',
        'version': 'N/A',
        'error': e.toString(),
        'platform': Platform.operatingSystem
      };
    }
  }
}