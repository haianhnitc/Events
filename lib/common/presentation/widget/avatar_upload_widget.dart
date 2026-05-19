import 'dart:io';

import 'package:events_app/common/utils/upload_helper.dart';
import 'package:events_app/dependency_injection/injection.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';
import 'package:events_app/feature/common/usecase/upload_file_params.dart';
import 'package:events_app/feature/common/usecase/upload_file_usecase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef OnAvatarUploadSuccess = void Function(int fileId, String url);
typedef OnBannerUploadSuccess = void Function(int fileId, String url);

class AvatarUploadWidget extends StatefulWidget {
  final String? previewUrl;
  final OnAvatarUploadSuccess? onSuccess;
  final FileType fileType;
  final double radius;
  final bool showCameraIcon;
  final VoidCallback? onTap;

  const AvatarUploadWidget({
    super.key,
    this.previewUrl,
    this.onSuccess,
    this.fileType = FileType.avatar,
    this.radius = 44,
    this.showCameraIcon = true,
    this.onTap,
  });

  @override
  State<AvatarUploadWidget> createState() => _AvatarUploadWidgetState();
}

class _AvatarUploadWidgetState extends State<AvatarUploadWidget> {
  final ImagePickerService _picker = ImagePickerService();
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    if (_isUploading) return;

    if (widget.onTap != null) {
      widget.onTap?.call();
      return;
    }

    final result = await _picker.pickSingleImage();
    if (result == null) return;

    setState(() => _isUploading = true);

    try {
      final uploadResult = await _uploadFile(result.filePath);

      if (uploadResult != null) {
        widget.onSuccess?.call(uploadResult.fileId, uploadResult.url);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<FileUploadResult?> _uploadFile(String filePath) async {
    final usecase = networkGetIt<UploadFileUsecase>();
    final result = await usecase(UploadFileParams(
      filePath: filePath,
      fileType: widget.fileType,
    ));

    return result.fold(
      (failure) {
        final message = failure.when(
          serverFailure: (_, msg) => msg,
          dataParsingFailure: () => 'Lỗi xử lý dữ liệu',
          noConnectionFailure: () => 'Không có kết nối mạng',
          systemFailure: (_, msg) => msg,
        );
        AppSnackbarUtils.showError('Upload thất bại', message ?? 'Vui lòng thử lại');
        return null;
      },
      (file) => FileUploadResult(fileId: file.fileId!, url: file.url!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _pickAndUpload,
          child: _buildAvatar(),
        ),
        if (_isUploading)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black26,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        if (widget.showCameraIcon)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickAndUpload,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xff06B6D4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAvatar() {
    final url = widget.previewUrl;

    if (url != null && url.isNotEmpty) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: const Color(0xFFE0F2FE),
        backgroundImage: url.startsWith('http')
            ? NetworkImage(url)
            : FileImage(File(url)) as ImageProvider,
      );
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: const Color(0xFFE0F2FE),
      child: Icon(
        Icons.person,
        size: widget.radius,
        color: const Color(0xff06B6D4),
      ),
    );
  }
}

class BannerUploadWidget extends StatefulWidget {
  final String? previewUrl;
  final OnBannerUploadSuccess? onSuccess;
  final VoidCallback? onRemove;
  final FileType fileType;
  final double height;
  final bool enabled;

  const BannerUploadWidget({
    super.key,
    this.previewUrl,
    this.onSuccess,
    this.onRemove,
    this.fileType = FileType.eventBanner,
    this.height = 160,
    this.enabled = true,
  });

  @override
  State<BannerUploadWidget> createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {
  final ImagePickerService _picker = ImagePickerService();
  bool _isUploading = false;

  Future<void> _pickAndUpload() async {
    if (!widget.enabled || _isUploading) return;

    final result = await _picker.pickSingleImage();
    if (result == null) return;

    setState(() => _isUploading = true);

    try {
      final uploadResult = await _uploadFile(result.filePath);

      if (uploadResult != null) {
        widget.onSuccess?.call(uploadResult.fileId, uploadResult.url);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<FileUploadResult?> _uploadFile(String filePath) async {
    final usecase = networkGetIt<UploadFileUsecase>();
    final result = await usecase(UploadFileParams(
      filePath: filePath,
      fileType: widget.fileType,
    ));

    return result.fold(
      (failure) {
        final message = failure.when(
          serverFailure: (_, msg) => msg,
          dataParsingFailure: () => 'Lỗi xử lý dữ liệu',
          noConnectionFailure: () => 'Không có kết nối mạng',
          systemFailure: (_, msg) => msg,
        );
        AppSnackbarUtils.showError('Upload thất bại', message ?? 'Vui lòng thử lại');
        return null;
      },
      (file) => FileUploadResult(fileId: file.fileId!, url: file.url!),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return _buildUploadingState();
    }

    final url = widget.previewUrl;
    if (url != null && url.isNotEmpty) {
      return _buildPreviewState(url);
    }

    return _buildPlaceholderState();
  }

  Widget _buildUploadingState() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(height: 8),
            Text(
              'Đang tải lên...',
              style: TextStyle(fontSize: 12, color: Color(0xff64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewState(String url) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: url.startsWith('http')
              ? Image.network(
                  url,
                  height: widget.height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderContent(),
                )
              : Image.file(
                  File(url),
                  height: widget.height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: [
              _ActionButton(
                icon: Icons.edit,
                onTap: _pickAndUpload,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.close,
                onTap: () => widget.onRemove?.call(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderState() {
    return GestureDetector(
      onTap: _pickAndUpload,
      child: _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_photo_alternate_outlined,
                size: 40, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              'Tải lên hình ảnh',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(
              'JPG, PNG (tối đa 5MB)',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
