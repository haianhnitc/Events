import 'package:events_app/common/utils/app_location_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocationErrorType enum', () {
    test('has distinct permissionDenied and permanentlyDenied values', () {
      expect(
        LocationErrorType.permissionDenied,
        isNot(LocationErrorType.permanentlyDenied),
      );
    });

    test('contains all expected values', () {
      expect(LocationErrorType.values, containsAll([
        LocationErrorType.permissionDenied,
        LocationErrorType.permanentlyDenied,
        LocationErrorType.locationServiceDisabled,
        LocationErrorType.timeout,
        LocationErrorType.unknown,
      ]));
    });
  });

  group('LocationError factories', () {
    test('permissionDenied() has correct type', () {
      final error = LocationError.permissionDenied();
      expect(error.type, LocationErrorType.permissionDenied);
      expect(error.message, isNotEmpty);
    });

    test('permanentlyDenied() has correct type distinct from permissionDenied', () {
      final error = LocationError.permanentlyDenied();
      expect(error.type, LocationErrorType.permanentlyDenied);
      expect(error.type, isNot(LocationErrorType.permissionDenied));
    });

    test('serviceDisabled() has correct type', () {
      final error = LocationError.serviceDisabled();
      expect(error.type, LocationErrorType.locationServiceDisabled);
    });

    test('timeout() has correct type', () {
      final error = LocationError.timeout();
      expect(error.type, LocationErrorType.timeout);
    });

    test('unknown() with detail includes detail in message', () {
      final error = LocationError.unknown('test detail');
      expect(error.type, LocationErrorType.unknown);
      expect(error.message, contains('test detail'));
    });

    test('unknown() without detail has fallback message', () {
      final error = LocationError.unknown();
      expect(error.type, LocationErrorType.unknown);
      expect(error.message, isNotEmpty);
    });
  });
}
