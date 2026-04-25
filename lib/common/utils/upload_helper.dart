import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:events_app/feature/common/domain/entity/file_entity.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

enum UploadFileType {
  image,
  document,
  any,
}

extension UploadFileTypeExtension on UploadFileType {
  List<XFile> validateAndGetImages(List<XFile> files) {
    return files.where((f) => _isImage(f.path)).toList();
  }

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  List<PlatformFile> validateAndGetDocuments(List<PlatformFile> files) {
    if (this == UploadFileType.image) {
      return [];
    }
    return files;
  }
}

class UploadResult {
  final String filePath;
  final String fileName;
  final int fileSize;
  final String mimeType;

  UploadResult({
    required this.filePath,
    required this.fileName,
    required this.fileSize,
    required this.mimeType,
  });
}

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();
  final PermissionHelper _permissionHelper = PermissionHelper();

  Future<UploadResult?> pickSingleImage({
    ImageSource source = ImageSource.gallery,
    int maxWidth = 2048,
    int maxHeight = 2048,
    int imageQuality = 85,
  }) async {
    try {
      if (source == ImageSource.gallery) {
        final permissionResult =
            await _permissionHelper.requestPhotosPermission();
        if (!permissionResult.granted) {
          if (permissionResult.status == PermissionStatus.permanentlyDenied) {
            _showPermissionDeniedDialog(
              'Photo Library',
              permissionResult.message,
            );
          }
          return null;
        }
      }

      if (source == ImageSource.camera) {
        final permissionResult =
            await _permissionHelper.requestCameraPermission();
        if (!permissionResult.granted) {
          if (permissionResult.status == PermissionStatus.permanentlyDenied) {
            _showPermissionDeniedDialog(
              'Camera',
              permissionResult.message,
            );
          }
          return null;
        }
      }

      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (file == null) return null;

      return UploadResult(
        filePath: file.path,
        fileName: file.name,
        fileSize: _getFileSize(file.path),
        mimeType: _getMimeType(file.path),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<UploadResult>> pickMultipleImages({
    int maxImages = 10,
    int maxWidth = 2048,
    int maxHeight = 2048,
    int imageQuality = 85,
  }) async {
    try {
      final permissionResult =
          await _permissionHelper.requestPhotosPermission();
      if (!permissionResult.granted) {
        if (permissionResult.status == PermissionStatus.permanentlyDenied) {
          _showPermissionDeniedDialog(
            'Photo Library',
            permissionResult.message,
          );
        }
        return [];
      }

      final List<XFile> files = await _picker.pickMultiImage(
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      final limitedFiles = files.take(maxImages).toList();

      final results = <UploadResult>[];
      for (final file in limitedFiles) {
        results.add(UploadResult(
          filePath: file.path,
          fileName: file.name,
          fileSize: _getFileSize(file.path),
          mimeType: _getMimeType(file.path),
        ));
      }

      return results;
    } catch (e) {
      return [];
    }
  }

  void _showPermissionDeniedDialog(String permissionName, String message) {
    AppSnackbarUtils.showError(
      'Quyền truy cập bị từ chối',
      'Không thể truy cập $permissionName. Vui lòng cấp quyền trong Cài đặt.',
    );
    Get.dialog(
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
            onPressed: () => Get.back(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AppSettings.openAppSettings();
            },
            child: const Text('Mở Cài đặt'),
          ),
        ],
      ),
    );
  }
}

class FilePickerService {
  Future<UploadResult?> pickDocument({
    List<String>? allowedExtensions,
    bool allowMultiple = false,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: false,
        withReadStream: false,
      );

      if (result == null) return null;
      if (result.files.isEmpty) return null;

      final file = result.files.first;
      final path = file.path;

      if (path == null) return null;

      return UploadResult(
        filePath: path,
        fileName: file.name,
        fileSize: file.size,
        mimeType: _getMimeType(path),
      );
    } catch (e) {
      return null;
    }
  }

  Future<List<UploadResult>> pickMultipleDocuments({
    List<String>? allowedExtensions,
    int maxFiles = 5,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withData: false,
        withReadStream: false,
      );

      if (result == null || result.files.isEmpty) return [];

      final limitedFiles = result.files.take(maxFiles).toList();
      final results = <UploadResult>[];

      for (final file in limitedFiles) {
        final path = file.path;
        if (path == null) continue;

        results.add(UploadResult(
          filePath: path,
          fileName: file.name,
          fileSize: file.size,
          mimeType: _getMimeType(path),
        ));
      }

      return results;
    } catch (e) {
      return [];
    }
  }
}

int _getFileSize(String path) {
  try {
    if (kIsWeb) return 0;
    final file = File(path);
    return file.existsSync() ? file.lengthSync() : 0;
  } catch (_) {
    return 0;
  }
}

String _getMimeType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'jpg':
    case 'jpeg':
      return 'image/jpeg';
    case 'png':
      return 'image/png';
    case 'gif':
      return 'image/gif';
    case 'webp':
      return 'image/webp';
    case 'bmp':
      return 'image/bmp';
    case 'pdf':
      return 'application/pdf';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return 'application/octet-stream';
  }
}

class FileUploadResult {
  final int fileId;
  final String url;

  const FileUploadResult({required this.fileId, required this.url});
}

class FileUploadHelper {
  final Future<FileUploadResult> Function(String filePath) uploadCallback;
  final void Function(int fileId) onFileIdChanged;
  final void Function(String url) onPreviewUrlChanged;
  final void Function(bool isUploading) onUploadingChanged;
  final void Function(String error) onError;

  const FileUploadHelper({
    required this.uploadCallback,
    required this.onFileIdChanged,
    required this.onPreviewUrlChanged,
    required this.onUploadingChanged,
    required this.onError,
  });

  Future<void> pickAndUpload(ImagePickerService picker) async {
    final result = await picker.pickSingleImage();
    if (result == null) return;

    onUploadingChanged(true);

    try {
      final uploadResult = await uploadCallback(result.filePath);

      onFileIdChanged(uploadResult.fileId);
      onPreviewUrlChanged(uploadResult.url);
      AppSnackbarUtils.showSuccess('Thành công', 'Tải ảnh lên thành công');
    } catch (e) {
      onError(e.toString());
    } finally {
      onUploadingChanged(false);
    }
  }
}
