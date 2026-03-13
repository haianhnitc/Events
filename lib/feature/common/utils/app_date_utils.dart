class AppDateUtils {
  const AppDateUtils._();

  static DateTime? parseApiDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value.trim());
  }

  static String formatDateOnly(DateTime? value,
      {String fallback = '--/--/----'}) {
    if (value == null) {
      return fallback;
    }

    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    return '$day/$month/$year';
  }
}
