import 'package:app_settings/app_settings.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionDialogHelper {
  const PermissionDialogHelper();

  Future<bool> requestWithDialog(
    Future<PermissionResult> Function() requester,
    String permissionName,
  ) async {
    var result = await requester();
    if (result.granted) return true;

    if (result.status == PermissionStatus.permanentlyDenied ||
        result.status == PermissionStatus.restricted) {
      await showPermissionDialog(permissionName, result.message,
          canRetry: false);
      return false;
    }

    final shouldRetry = await showPermissionDialog(
      permissionName,
      result.message,
      canRetry: true,
    );
    if (!shouldRetry) return false;

    result = await requester();
    if (result.granted) return true;

    await showPermissionDialog(permissionName, result.message, canRetry: false);
    return false;
  }

  Future<bool> showRationaleDialog({
    required String title,
    required String message,
    String declineLabel = 'Để sau',
    String confirmLabel = 'Bật',
  }) async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(declineLabel),
              ),
              ElevatedButton(
                onPressed: () => Get.back(result: true),
                child: Text(confirmLabel),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> showPermissionDialog(
    String permissionName,
    String message, {
    required bool canRetry,
  }) async {
    return await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Quyền truy cập bị từ chối'),
            content: Text(
              'Ứng dụng cần quyền "$permissionName" để thực hiện chức năng này.\n\n$message\n\nVui lòng cấp quyền trong Cài đặt ứng dụng.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('Hủy'),
              ),
              if (canRetry)
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  child: const Text('Thử lại'),
                ),
              ElevatedButton(
                onPressed: () {
                  Get.back(result: false);
                  AppSettings.openAppSettings();
                },
                child: const Text('Mở Cài đặt'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
