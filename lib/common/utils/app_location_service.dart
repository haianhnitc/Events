import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:events_app/common/utils/permission_helper.dart';

class LocationCoords {
  final double latitude;
  final double longitude;

  const LocationCoords({
    required this.latitude,
    required this.longitude,
  });
}

enum LocationErrorType {
  permissionDenied,
  locationServiceDisabled,
  timeout,
  unknown,
}

class LocationError {
  final LocationErrorType type;
  final String message;

  const LocationError({
    required this.type,
    required this.message,
  });

  factory LocationError.permissionDenied() => const LocationError(
        type: LocationErrorType.permissionDenied,
        message: 'Không có quyền truy cập vị trí',
      );

  factory LocationError.serviceDisabled() => const LocationError(
        type: LocationErrorType.locationServiceDisabled,
        message: 'Dịch vụ định vị đang tắt. Vui lòng bật GPS.',
      );

  factory LocationError.timeout() => const LocationError(
        type: LocationErrorType.timeout,
        message: 'Không lấy được vị trí. Vui lòng thử lại.',
      );

  factory LocationError.unknown([String? detail]) => LocationError(
        type: LocationErrorType.unknown,
        message: detail ?? 'Đã xảy ra lỗi khi lấy vị trí',
      );
}

class AppLocationService {
  Future<({LocationCoords? coords, LocationError? error})>
      getCurrentLocation() async {
    if (kIsWeb) {
      return (
        coords: null,
        error: LocationError.unknown('Không hỗ trợ trên web')
      );
    }

    final permissionResult = await _checkAndRequestPermission();
    if (!permissionResult.granted) {
      final errorType =
          permissionResult.status == PermissionStatus.permanentlyDenied
              ? LocationErrorType.permissionDenied
              : LocationErrorType.permissionDenied;
      return (
        coords: null,
        error: LocationError(
          type: errorType,
          message: permissionResult.message,
        ),
      );
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return (
        coords: null,
        error: LocationError.serviceDisabled(),
      );
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return (
        coords: LocationCoords(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
        error: null,
      );
    } on LocationServiceDisabledException {
      return (
        coords: null,
        error: LocationError.serviceDisabled(),
      );
    } on TimeoutException {
      return (
        coords: null,
        error: LocationError.timeout(),
      );
    } catch (e) {
      debugPrint('AppLocationService: getCurrentLocation error: $e');
      return (
        coords: null,
        error: LocationError.unknown('Lỗi: $e'),
      );
    }
  }

  Future<bool> isLocationServiceEnabled() async {
    if (kIsWeb) return false;
    return await Geolocator.isLocationServiceEnabled();
  }

  Future<PermissionResult> _checkAndRequestPermission() async {
    final helper = PermissionHelper();
    return await helper.requestLocationPermission();
  }
}
