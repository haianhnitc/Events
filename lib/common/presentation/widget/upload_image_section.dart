import 'dart:io';
import 'package:flutter/material.dart';

class ImageUploadSection extends StatelessWidget {
  final String? previewUrl;
  final bool isUploading;
  final VoidCallback onPickAndUpload;
  final VoidCallback onRemove;
  final double height;
  final String placeholderTitle;
  final String placeholderSubtitle;

  const ImageUploadSection({
    super.key,
    this.previewUrl,
    required this.isUploading,
    required this.onPickAndUpload,
    required this.onRemove,
    this.height = 160,
    this.placeholderTitle = 'Tải lên hình ảnh',
    this.placeholderSubtitle = 'JPG, PNG (tối đa 5MB)',
  });

  @override
  Widget build(BuildContext context) {
    if (isUploading) {
      return _buildUploadingState();
    }
    if (previewUrl != null && previewUrl!.isNotEmpty) {
      return _buildPreviewState();
    }
    return _buildPlaceholderState();
  }

  Widget _buildUploadingState() {
    return Container(
      height: height,
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

  Widget _buildPreviewState() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: previewUrl!.startsWith('http')
              ? Image.network(
                  previewUrl!,
                  height: height,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _buildPlaceholderContent(),
                )
              : Image.file(
                  File(previewUrl!),
                  height: height,
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
                onTap: onPickAndUpload,
              ),
              const SizedBox(width: 8),
              _ActionButton(
                icon: Icons.close,
                onTap: onRemove,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderState() {
    return GestureDetector(
      onTap: onPickAndUpload,
      child: _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 40,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 8),
            Text(
              placeholderTitle,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(
              placeholderSubtitle,
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
