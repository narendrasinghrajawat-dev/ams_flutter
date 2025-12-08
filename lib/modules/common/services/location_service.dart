// lib/services/location/location_service.dart
import 'dart:async';
import 'dart:io' show Platform;
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final bool ok;
  final String? message;
  final Position? position;
  LocationResult({required this.ok, this.message, this.position});
}

class LocationService {
  LocationService._private();
  static final LocationService instance = LocationService._private();

  Duration timeout = const Duration(seconds: 12);

  Future<LocationResult> getCurrentLocation({Duration? timeoutOverride}) async {
    final Duration effective = timeoutOverride ?? timeout;

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

      print('post iset eh$pos');

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
  }
}
