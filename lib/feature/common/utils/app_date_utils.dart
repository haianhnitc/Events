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
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }

  static String formatDateOnly(DateTime? value,
      {String fallback = '--/--/----'}) {
    return formatDate(value, fallback: fallback);
  }

  static String formatDateTime(DateTime? value,
      {String fallback = '--h--p --/--/----'}) {
    if (value == null) {
      return fallback;
    }

    final dateTime = value.toLocal();
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year.toString();
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '${hour}h${minute}p - $day/$month/$year';
  }
}
