import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionResult {
  final bool granted;
  final PermissionStatus status;
  final String message;

  const PermissionResult({
    required this.granted,
    required this.status,
    required this.message,
  });

  factory PermissionResult.granted() => const PermissionResult(
        granted: true,
        status: PermissionStatus.granted,
        message: 'Permission granted',
      );

  factory PermissionResult.denied(String reason) => PermissionResult(
        granted: false,
        status: PermissionStatus.denied,
        message: reason,
      );

  factory PermissionResult.permanentlyDenied(String permissionName) =>
      PermissionResult(
        granted: false,
        status: PermissionStatus.permanentlyDenied,
        message:
            '$permissionName permission is permanently denied. Please enable it in Settings.',
      );

  factory PermissionResult.restricted(String permissionName) => PermissionResult(
        granted: false,
        status: PermissionStatus.restricted,
        message: '$permissionName permission is restricted on this device.',
      );

  factory PermissionResult.unknown(String permissionName) => PermissionResult(
        granted: false,
        status: PermissionStatus.denied,
        message: '$permissionName permission status is unknown.',
      );
}

class PermissionHelper {
  Future<PermissionResult> requestPhotosPermission() async {
    if (kIsWeb) {
      return PermissionResult.granted();
    }

    try {
      final status = await Permission.photos.status;

      if (status.isGranted) {
        return PermissionResult.granted();
      }

      if (status.isDenied) {
        final result = await Permission.photos.request();
        return _mapStatusToResult(result, 'Photo library');
      }

      if (status.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied('Photo library');
      }

      if (status.isRestricted) {
        return PermissionResult.restricted('Photo library');
      }

      return PermissionResult.unknown('Photo library');
    } catch (e) {
      return PermissionResult.denied('Failed to request photo library permission');
    }
  }

  Future<PermissionResult> requestCameraPermission() async {
    if (kIsWeb) {
      return PermissionResult.granted();
    }

    try {
      final status = await Permission.camera.status;

      if (status.isGranted) {
        return PermissionResult.granted();
      }

      if (status.isDenied) {
        final result = await Permission.camera.request();
        return _mapStatusToResult(result, 'Camera');
      }

      if (status.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied('Camera');
      }

      if (status.isRestricted) {
        return PermissionResult.restricted('Camera');
      }

      return PermissionResult.unknown('Camera');
    } catch (e) {
      return PermissionResult.denied('Failed to request camera permission');
    }
  }

  Future<PermissionResult> requestLocationPermission() async {
    if (kIsWeb) {
      return PermissionResult.granted();
    }

    try {
      final status = await Permission.locationWhenInUse.status;

      if (status.isGranted) {
        return PermissionResult.granted();
      }

      if (status.isDenied) {
        final result = await Permission.locationWhenInUse.request();
        return _mapStatusToResult(result, 'Location');
      }

      if (status.isPermanentlyDenied) {
        return PermissionResult.permanentlyDenied('Location');
      }

      if (status.isRestricted) {
        return PermissionResult.restricted('Location');
      }

      return PermissionResult.unknown('Location');
    } catch (e) {
      return PermissionResult.denied('Failed to request location permission');
    }
  }

  Future<bool> openSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      return false;
    }
  }

  Future<bool> shouldShowRequestRationale(Permission permission) async {
    if (kIsWeb) {
      return false;
    }

    try {
      return await permission.shouldShowRequestRationale;
    } catch (e) {
      return false;
    }
  }

  PermissionResult _mapStatusToResult(PermissionStatus status, String name) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return PermissionResult.granted();
      case PermissionStatus.denied:
        return PermissionResult.denied('$name permission is denied');
      case PermissionStatus.permanentlyDenied:
        return PermissionResult.permanentlyDenied(name);
      case PermissionStatus.restricted:
        return PermissionResult.restricted(name);
      case PermissionStatus.provisional:
        return PermissionResult.granted(); 
    }
  }
}
