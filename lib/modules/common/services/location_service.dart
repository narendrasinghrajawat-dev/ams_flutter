// lib/services/location/location_service.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:attedance_management_system/modules/common/controller/loading_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LocationResult {
  final bool ok;
  final String? message;
  final Position? position;
  LocationResult({required this.ok, this.message, this.position});
}

class LocationService {
  LocationService._private();
  static final LocationService instance = LocationService._private();
  final LoadingController _loadingController = Get.find<LoadingController>();


  Duration timeout = const Duration(seconds: 12);

  Future<LocationResult> getCurrentLocation({Duration? timeoutOverride}) async {
    final Duration effective = timeoutOverride ?? timeout;
    _loadingController.start();
    try {
      // 1) Is location service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // try to return last known as fallback
        final last = await Geolocator.getLastKnownPosition();
        if (last != null) {
          return LocationResult(ok: true, position: last, message: 'Using last known location (GPS off).');
        }
        return LocationResult(ok: false, message: 'Location services are disabled on device.');
      }

      // 2) Permissions
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult(ok: false, message: 'Location permission denied by user.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult(ok: false, message:
        'Location permission permanently denied. Please enable it from settings.');
      }

      // 3) Get current position (with timeout)
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).timeout(effective);

      return LocationResult(ok: true, position: pos);
    } on TimeoutException {
      // fallback to last known if available
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        return LocationResult(ok: true, position: last, message: 'Timed out — using last known location.');
      }
      return LocationResult(ok: false, message: 'Location request timed out.');
    } catch (e) {
      // general fallback
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        return LocationResult(ok: true, position: last, message: 'Failed to get fresh location — using last known.');
      }
      return LocationResult(ok: false, message: 'Failed to get location: $e');
    }
     finally{
       _loadingController.hide();

     }
  }

  double _degToRad(double deg) => deg * (math.pi / 180.0);


  /// Returns distance (in meters) between two lat/long points.
  double calculateDistanceInMeters(double startLat, double startLng, double endLat, double endLng,) {
    const earthRadius = 6371000.0; // meters

    final dLat = _degToRad(endLat - startLat);
    final dLng = _degToRad(endLng - startLng);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degToRad(startLat)) *
            math.cos(_degToRad(endLat)) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// ✅ Common function: is user within given radius of target (e.g. office)?
  bool isWithinRadius({required double userLat, required double userLng, required double targetLat, required double targetLng, double radiusInMeters = 100.0,}) {
    final distance = calculateDistanceInMeters(userLat, userLng, targetLat, targetLng);

    return distance <= radiusInMeters;
  }



}
