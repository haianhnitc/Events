import 'package:events_app/common/utils/permission_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('PermissionResult factories', () {
    test('granted() sets granted=true and correct status', () {
      final result = PermissionResult.granted();
      expect(result.granted, isTrue);
      expect(result.status, PermissionStatus.granted);
    });

    test('denied() sets granted=false and status=denied', () {
      final result = PermissionResult.denied('reason');
      expect(result.granted, isFalse);
      expect(result.status, PermissionStatus.denied);
      expect(result.message, 'reason');
    });

    test('permanentlyDenied() sets granted=false and status=permanentlyDenied', () {
      final result = PermissionResult.permanentlyDenied('Camera');
      expect(result.granted, isFalse);
      expect(result.status, PermissionStatus.permanentlyDenied);
      expect(result.message, contains('Camera'));
    });

    test('restricted() sets granted=false and status=restricted', () {
      final result = PermissionResult.restricted('Camera');
      expect(result.granted, isFalse);
      expect(result.status, PermissionStatus.restricted);
      expect(result.message, contains('Camera'));
    });

    test('unknown() defaults to denied status', () {
      final result = PermissionResult.unknown('Photo library');
      expect(result.granted, isFalse);
      expect(result.status, PermissionStatus.denied);
    });
  });
}
