import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:events_app/feature/common/utils/app_snackbar_utils.dart';

class AppMapUtils {
  const AppMapUtils._();

  static Future<void> openVenueDirection(
    BuildContext context, {
    String? mapUrl,
    double? latitude,
    double? longitude,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final String normalizedMapUrl = (mapUrl ?? '').trim();
    final Uri? mapUri =
        normalizedMapUrl.isNotEmpty ? Uri.tryParse(normalizedMapUrl) : null;
    final bool hasCoordinates = latitude != null && longitude != null;
    final Uri? coordinateUri = hasCoordinates
        ? Uri.parse(
            'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&travelmode=driving',
          )
        : null;

    final Uri? primaryUri = mapUri ?? coordinateUri;

    if (primaryUri == null) {
      AppSnackbarUtils.showError(
        'Không thể mở bản đồ',
        'Vị trí hiện tại không khả dụng.',
      );
      return;
    }

    bool launched = await launchUrl(
      primaryUri,
      mode: LaunchMode.externalApplication,
    );

    final Uri? fallbackUri = primaryUri == mapUri ? coordinateUri : mapUri;

    if (!launched &&
        fallbackUri != null &&
        fallbackUri.toString() != primaryUri.toString()) {
      launched = await launchUrl(
        fallbackUri,
        mode: LaunchMode.externalApplication,
      );
    }

    if (!launched) {
      AppSnackbarUtils.showError(
        'Không thể mở bản đồ',
        'Không thể mở Google Maps.',
      );
    }
  }

  static ({double? latitude, double? longitude})? parseLatLngFromUrl(
      String url) {
    if (url.isEmpty) return null;

    final trimmed = url.trim();

    final atMatch = RegExp(r'@(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(trimmed);
    if (atMatch != null) {
      final lat = double.tryParse(atMatch.group(1)!);
      final lng = double.tryParse(atMatch.group(2)!);
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    }

    final llMatch = RegExp(r'[?&]ll=(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(trimmed);
    if (llMatch != null) {
      final lat = double.tryParse(llMatch.group(1)!);
      final lng = double.tryParse(llMatch.group(2)!);
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    }

    final qMatch =
        RegExp(r'[?&]q=(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(trimmed);
    if (qMatch != null) {
      final lat = double.tryParse(qMatch.group(1)!);
      final lng = double.tryParse(qMatch.group(2)!);
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    }

    final destMatch = RegExp(r'[?&]destination=(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(trimmed);
    if (destMatch != null) {
      final lat = double.tryParse(destMatch.group(1)!);
      final lng = double.tryParse(destMatch.group(2)!);
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    }

    final queryMatch = RegExp(r'[?&]query=(-?\d+\.?\d*),(-?\d+\.?\d*)').firstMatch(trimmed);
    if (queryMatch != null) {
      final lat = double.tryParse(queryMatch.group(1)!);
      final lng = double.tryParse(queryMatch.group(2)!);
      if (lat != null && lng != null) {
        return (latitude: lat, longitude: lng);
      }
    }

    return null;
  }

  static String? buildGoogleMapsSearchUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  static String buildGoogleMapsShareUrl(
      double latitude, double longitude, String? label) {
    if (label != null && label.isNotEmpty) {
      return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$label';
    }
    return 'https://www.google.com/maps?q=$latitude,$longitude';
  }

  static String? normalizeMapUrl(String url) {
    if (url.isEmpty) return null;

    if (url.contains('google.com/maps')) {
      if (!url.contains('@')) {
        return url;
      }
    }
    return url;
  }

  static bool isValidGoogleMapsUrl(String url) {
    if (url.isEmpty) return false;
    return url.contains('google.com/maps') ||
        parseLatLngFromUrl(url) != null;
  }
}
