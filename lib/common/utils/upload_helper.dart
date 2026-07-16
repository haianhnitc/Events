import 'dart:io';

import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/common/utils/permission_dialog_helper.dart';
import 'package:events_app/common/utils/permission_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

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
  final ImagePicker _picker;
  final PermissionHelper _permissionHelper;
  final PermissionDialogHelper _dialogHelper;

  ImagePickerService({
    ImagePicker? picker,
    PermissionHelper? permissionHelper,
    PermissionDialogHelper? dialogHelper,
  })  : _picker = picker ?? ImagePicker(),
        _permissionHelper = permissionHelper ?? PermissionHelper(),
        _dialogHelper = dialogHelper ?? const PermissionDialogHelper();

  Future<UploadResult?> pickSingleImage({
    ImageSource source = ImageSource.gallery,
    int maxWidth = 2048,
    int maxHeight = 2048,
    int imageQuality = 85,
  }) async {
    try {
      if (source == ImageSource.gallery) {
        final granted = await _dialogHelper.requestWithDialog(
          _permissionHelper.requestPhotosPermission,
          'Photo Library',
        );
        if (!granted) return null;
      }

      if (source == ImageSource.camera) {
        final granted = await _dialogHelper.requestWithDialog(
          _permissionHelper.requestCameraPermission,
          'Camera',
        );
        if (!granted) return null;
      }

      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (file == null) return null;

      final validate = _validateImageFile(file);
      if (!validate.ok) {
        AppSnackbarUtils.showError(
          'Định dạng không hỗ trợ',
          validate.message,
        );
        return null;
      }

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

  ({bool ok, String message}) _validateImageFile(XFile file) {
    final ext = file.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext)) {
      return (ok: false, message: 'Chỉ hỗ trợ ảnh JPG, PNG, GIF, WebP. Vui lòng chọn ảnh khác.');
    }

    if (!kIsWeb) {
      final magicBytes = _readMagicBytes(file.path);
      if (magicBytes != null && !_isValidMagicBytes(magicBytes)) {
        return (
          ok: false,
          message: 'File "$ext" không hợp lệ. Chỉ hỗ trợ ảnh JPG, PNG, GIF, WebP.',
        );
      }
    }

    return (ok: true, message: '');
  }

  List<int>? _readMagicBytes(String path) {
    try {
      final file = File(path);
      if (!file.existsSync()) return null;
      final raf = file.openSync(mode: FileMode.read);
      final bytes = raf.readSync(12);
      raf.closeSync();
      return bytes;
    } catch (_) {
      return null;
    }
  }

  bool _isValidMagicBytes(List<int> bytes) {
    if (bytes.length < 4) return false;

    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) return true;

    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) return true;

    // GIF: 47 49 46 38
    if (bytes[0] == 0x47 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x38) return true;

    // WebP: 52 49 46 46 .... 57 45 42 50
    if (bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
        bytes.length >= 12 && bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) {
      return true;
    }

    return false;
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
