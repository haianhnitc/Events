import 'package:events_app/common/utils/app_location_service.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

class _StubPermissionHelper extends PermissionHelper {
  final PermissionResult result;
  _StubPermissionHelper(this.result);

  @override
  Future<PermissionResult> requestLocationPermission() async => result;
}

void main() {
  group('AppLocationService — permission error mapping', () {
    test('permanentlyDenied permission → error type is permanentlyDenied', () async {
      final service = AppLocationService(
        permissionHelper: _StubPermissionHelper(
          PermissionResult.permanentlyDenied('Location'),
        ),
      );
      final result = await service.getCurrentLocation();

      expect(result.coords, isNull);
      expect(result.error, isNotNull);
      expect(result.error!.type, LocationErrorType.permanentlyDenied);
    });

    test('denied permission → error type is permissionDenied', () async {
      final service = AppLocationService(
        permissionHelper: _StubPermissionHelper(
          PermissionResult.denied('Location permission denied'),
        ),
      );
      final result = await service.getCurrentLocation();

      expect(result.coords, isNull);
      expect(result.error, isNotNull);
      expect(result.error!.type, LocationErrorType.permissionDenied);
    });

    test('restricted permission → error type is permissionDenied (not permanent)', () async {
      final service = AppLocationService(
        permissionHelper: _StubPermissionHelper(
          PermissionResult.restricted('Location'),
        ),
      );
      final result = await service.getCurrentLocation();

      expect(result.coords, isNull);
      expect(result.error, isNotNull);
      // restricted does not go to permanentlyDenied branch
      expect(result.error!.type, isNot(LocationErrorType.permanentlyDenied));
    });

    test('permanentlyDenied and denied produce different error types', () async {
      final permanent = AppLocationService(
        permissionHelper: _StubPermissionHelper(
          PermissionResult.permanentlyDenied('Location'),
        ),
      );
      final denied = AppLocationService(
        permissionHelper: _StubPermissionHelper(
          PermissionResult.denied('denied'),
        ),
      );

      final permanentResult = await permanent.getCurrentLocation();
      final deniedResult = await denied.getCurrentLocation();

      expect(permanentResult.error!.type, LocationErrorType.permanentlyDenied);
      expect(deniedResult.error!.type, LocationErrorType.permissionDenied);
      expect(
        permanentResult.error!.type,
        isNot(deniedResult.error!.type),
      );
    });
  });
}
