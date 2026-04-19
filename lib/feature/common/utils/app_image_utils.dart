import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppImageUtils {
  const AppImageUtils._();

  static bool isMockImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(value.trim());
    if (uri == null) {
      return false;
    }

    final host = uri.host.toLowerCase();
    return host == 'example.com' || host.endsWith('.example.com');
  }

  static bool isValidNetworkImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(value.trim());
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  static Widget buildNetworkImage({
    required String? imageUrl,
    required Widget placeholder,
    Widget? errorPlaceholder,
    required BoxFit fit,
    int? memCacheWidth,
    int? memCacheHeight,
    int? maxWidthDiskCache,
    int? maxHeightDiskCache,
  }) {
    final errorWidget = errorPlaceholder ?? placeholder;
    if (!isValidNetworkImageUrl(imageUrl) || isMockImageUrl(imageUrl)) {
      return errorWidget;
    }

    final normalizedUrl = imageUrl!.trim();
    final isSvg = normalizedUrl.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return SvgPicture.network(
        normalizedUrl,
        fit: fit,
        placeholderBuilder: (context) => placeholder,
      );
    }

    return CachedNetworkImage(
      imageUrl: normalizedUrl,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      maxWidthDiskCache: maxWidthDiskCache,
      maxHeightDiskCache: maxHeightDiskCache,
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }

  static Widget buildImagePlaceholder({
    Color backgroundColor = const Color(0xffF3F4F6),
    Color iconColor = const Color(0xff9CA3AF),
    double iconSize = 24,
    IconData icon = Icons.image_not_supported_outlined,
  }) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
      ),
    );
  }

  static Widget buildImageLoadingPlaceholder({
    Color backgroundColor = const Color(0xffF3F4F6),
    Color spinnerColor = const Color(0xff06B6D4),
    double spinnerSize = 24,
  }) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          width: spinnerSize,
          height: spinnerSize,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(spinnerColor),
            strokeWidth: 2.5,
          ),
        ),
      ),
    );
  }
}
