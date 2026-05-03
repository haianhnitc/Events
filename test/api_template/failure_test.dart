import 'package:events_app/api_template/services/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureEntity - Factory Constructors', () {
    test('serverFailure tao failure voi code va message', () {
      const failure = FailureEntity.serverFailure('500', 'Internal Server Error');

      final result = failure.when(
        serverFailure: (code, message) => (code: code, message: message),
        dataParsingFailure: () => (code: null, message: null),
        noConnectionFailure: () => (code: null, message: null),
        systemFailure: (code, message) => (code: null, message: null),
      );

      expect(result.code, '500');
      expect(result.message, 'Internal Server Error');
    });

    test('dataParsingFailure tao failure', () {
      const failure = FailureEntity.dataParsingFailure();

      final isDataParsing = failure.when(
        serverFailure: (_, __) => false,
        dataParsingFailure: () => true,
        noConnectionFailure: () => false,
        systemFailure: (_, __) => false,
      );

      expect(isDataParsing, true);
    });

    test('noConnectionFailure tao failure', () {
      const failure = FailureEntity.noConnectionFailure();

      final isNoConnection = failure.when(
        serverFailure: (_, __) => false,
        dataParsingFailure: () => false,
        noConnectionFailure: () => true,
        systemFailure: (_, __) => false,
      );

      expect(isNoConnection, true);
    });

    test('systemFailure tao failure voi code va message', () {
      const failure = FailureEntity.systemFailure('SYS_001', 'System error occurred');

      final result = failure.when(
        serverFailure: (_, __) => (code: null, message: null),
        dataParsingFailure: () => (code: null, message: null),
        noConnectionFailure: () => (code: null, message: null),
        systemFailure: (code, message) => (code: code, message: message),
      );

      expect(result.code, 'SYS_001');
      expect(result.message, 'System error occurred');
    });
  });

  group('FailureEntity - errorCode()', () {
    test('errorCode tra ve code cho serverFailure', () {
      const failure = FailureEntity.serverFailure('404', 'Not Found');
      expect(failure.errorCode(), '404');
    });

    test('errorCode tra ve code cho systemFailure', () {
      const failure = FailureEntity.systemFailure('ERR_001', 'Error');
      expect(failure.errorCode(), 'ERR_001');
    });

    test('errorCode tra ve ma mac dinh cho dataParsingFailure', () {
      const failure = FailureEntity.dataParsingFailure();
      expect(failure.errorCode(), '12002');
    });

    test('errorCode tra ve ma mac dinh cho noConnectionFailure', () {
      const failure = FailureEntity.noConnectionFailure();
      expect(failure.errorCode(), '12001');
    });
  });

  group('FailureEntity - Freezed Equality', () {
    test('hai serverFailure cung data thi bang nhau', () {
      const failure1 = FailureEntity.serverFailure('500', 'Error');
      const failure2 = FailureEntity.serverFailure('500', 'Error');

      expect(failure1, equals(failure2));
    });

    test('hai serverFailure khac data thi khong bang nhau', () {
      const failure1 = FailureEntity.serverFailure('500', 'Error 1');
      const failure2 = FailureEntity.serverFailure('500', 'Error 2');

      expect(failure1, isNot(equals(failure2)));
    });

    test('hai dataParsingFailure thi bang nhau', () {
      const failure1 = FailureEntity.dataParsingFailure();
      const failure2 = FailureEntity.dataParsingFailure();

      expect(failure1, equals(failure2));
    });

    test('hai noConnectionFailure thi bang nhau', () {
      const failure1 = FailureEntity.noConnectionFailure();
      const failure2 = FailureEntity.noConnectionFailure();

      expect(failure1, equals(failure2));
    });

    test('hai systemFailure cung data thi bang nhau', () {
      const failure1 = FailureEntity.systemFailure('SYS_001', 'System Error');
      const failure2 = FailureEntity.systemFailure('SYS_001', 'System Error');

      expect(failure1, equals(failure2));
    });

    test('serverFailure va systemFailure cung code/message khong bang nhau', () {
      const failure1 = FailureEntity.serverFailure('500', 'Error');
      const failure2 = FailureEntity.systemFailure('500', 'Error');

      expect(failure1, isNot(equals(failure2)));
    });
  });
}
