import 'package:events_app/common/timezone_helper.dart';

class AppDateUtils {
  const AppDateUtils._();

  static DateTime? parseApiDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(value.trim());
  }

  static String formatDate(DateTime? value, {String fallback = '--/--/----'}) {
    if (value == null) return fallback;
    final hcmDate = TimezoneHelper.toAsiaHCM(value.toUtc());
    final day = hcmDate.day.toString().padLeft(2, '0');
    final month = hcmDate.month.toString().padLeft(2, '0');
    final year = hcmDate.year.toString();
    return '$day/$month/$year';
  }

  static String formatDateOnly(DateTime? value, {String fallback = '--/--/----'}) {
    return formatDate(value, fallback: fallback);
  }

  static String formatDateTime(DateTime? value, {String fallback = '--h--p --/--/----'}) {
    if (value == null) {
      return fallback;
    }
    final hcmDate = TimezoneHelper.toAsiaHCM(value.toUtc());
    final day = hcmDate.day.toString().padLeft(2, '0');
    final month = hcmDate.month.toString().padLeft(2, '0');
    final year = hcmDate.year.toString();
    final hour = hcmDate.hour.toString().padLeft(2, '0');
    final minute = hcmDate.minute.toString().padLeft(2, '0');
    return '${hour}h${minute}p - $day/$month/$year';
  }
}
