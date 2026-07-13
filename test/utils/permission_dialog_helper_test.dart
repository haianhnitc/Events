import 'package:events_app/common/utils/permission_dialog_helper.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Subclass that bypasses Get.dialog so logic can be tested without a widget tree.
class _TestDialogHelper extends PermissionDialogHelper {
  final List<({String name, String message, bool canRetry})> calls = [];

  /// Controls what the dialog "returns" (true = user tapped Thử lại, false = Hủy/Mở Cài đặt).
  bool dialogResult;

  _TestDialogHelper({this.dialogResult = false});

  @override
  Future<bool> showPermissionDialog(
    String permissionName,
    String message, {
    required bool canRetry,
  }) async {
    calls.add((name: permissionName, message: message, canRetry: canRetry));
    return dialogResult;
  }
}

void main() {
  group('PermissionDialogHelper.requestWithDialog', () {
    test('returns true and shows no dialog when already granted', () async {
      final helper = _TestDialogHelper();
      var callCount = 0;

      final granted = await helper.requestWithDialog(
        () async {
          callCount++;
          return PermissionResult.granted();
        },
        'Camera',
      );

      expect(granted, isTrue);
      expect(callCount, 1);
      expect(helper.calls, isEmpty);
    });

    test('shows dialog with canRetry=true when denied, then returns false when user cancels', () async {
      final helper = _TestDialogHelper(dialogResult: false);

      final granted = await helper.requestWithDialog(
        () async => PermissionResult.denied('denied'),
        'Photo Library',
      );

      expect(granted, isFalse);
      expect(helper.calls.length, 1);
      expect(helper.calls.first.canRetry, isTrue);
      expect(helper.calls.first.name, 'Photo Library');
    });

    test('retries and returns true when user taps Thử lại and second request succeeds', () async {
      final helper = _TestDialogHelper(dialogResult: true);
      var callCount = 0;

      final granted = await helper.requestWithDialog(
        () async {
          callCount++;
          return callCount == 1
              ? PermissionResult.denied('denied')
              : PermissionResult.granted();
        },
        'Camera',
      );

      expect(granted, isTrue);
      expect(callCount, 2);
      expect(helper.calls.length, 1);
      expect(helper.calls.first.canRetry, isTrue);
    });

    test('shows Settings-only dialog (canRetry=false) when retry also fails', () async {
      final helper = _TestDialogHelper(dialogResult: true);
      var callCount = 0;

      final granted = await helper.requestWithDialog(
        () async {
          callCount++;
          return PermissionResult.denied('still denied');
        },
        'Photo Library',
      );

      expect(granted, isFalse);
      expect(callCount, 2);
      expect(helper.calls.length, 2);
      expect(helper.calls[0].canRetry, isTrue);   // first dialog: có nút Thử lại
      expect(helper.calls[1].canRetry, isFalse);  // second dialog: chỉ Mở Cài đặt
    });

    test('shows Settings-only dialog immediately when permanentlyDenied', () async {
      final helper = _TestDialogHelper();

      final granted = await helper.requestWithDialog(
        () async => PermissionResult.permanentlyDenied('Camera'),
        'Camera',
      );

      expect(granted, isFalse);
      expect(helper.calls.length, 1);
      expect(helper.calls.first.canRetry, isFalse);
    });

    test('shows Settings-only dialog immediately when restricted', () async {
      final helper = _TestDialogHelper();

      final granted = await helper.requestWithDialog(
        () async => PermissionResult.restricted('Photo Library'),
        'Photo Library',
      );

      expect(granted, isFalse);
      expect(helper.calls.length, 1);
      expect(helper.calls.first.canRetry, isFalse);
    });

    test('requester is only called once when denied and user cancels', () async {
      final helper = _TestDialogHelper(dialogResult: false);
      var callCount = 0;

      await helper.requestWithDialog(
        () async {
          callCount++;
          return PermissionResult.denied('denied');
        },
        'Camera',
      );

      expect(callCount, 1);
    });

    test('requester is only called once when permanentlyDenied', () async {
      final helper = _TestDialogHelper();
      var callCount = 0;

      await helper.requestWithDialog(
        () async {
          callCount++;
          return PermissionResult.permanentlyDenied('Camera');
        },
        'Camera',
      );

      expect(callCount, 1);
    });
  });
}
