import 'package:flutter/material.dart';
import 'package:events_app/feature/common/utils/app_date_utils.dart';

class AppDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final void Function(DateTime?) onChanged;
  final String? Function(DateTime?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final String placeholder;
  final bool showTime;
  final IconData? icon;

  const AppDateTimePicker({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.placeholder = 'Chọn ngày',
    this.showTime = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff475569),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: value != null
                    ? const Color(0xFF06B6D4).withOpacity(0.5)
                    : const Color(0xFFE2E8F0),
                width: value != null ? 1.5 : 1,
              ),
              boxShadow: value != null
                  ? [
                      BoxShadow(
                        color: const Color(0xFF06B6D4).withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: value != null
                        ? const Color(0xFF06B6D4).withOpacity(0.1)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ?? Icons.calendar_month_rounded,
                    size: 18,
                    color: value != null
                        ? const Color(0xFF06B6D4)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        value != null
                            ? AppDateUtils.formatDate(value!)
                            : placeholder,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              value != null ? FontWeight.w600 : FontWeight.w400,
                          color: value != null
                              ? const Color(0xff1E293B)
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                      if (value != null && showTime)
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Text(
                            AppDateUtils.formatDateTime(value!),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (value != null)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: Color(0xFF94A3B8),
                  ),
              ],
            ),
          ),
        ),
        if (validator != null && value != null) ...[
          const SizedBox(height: 4),
          Builder(
            builder: (ctx) {
              final error = validator!(value);
              if (error == null) return const SizedBox.shrink();
              return Text(
                error,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFE53935),
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Future<void> _showPicker(BuildContext context) async {
    final first = firstDate ?? DateTime.now();
    final effectiveInitial = value ?? initialDate;
    final initial = effectiveInitial != null && !effectiveInitial.isBefore(first)
        ? effectiveInitial
        : first.add(const Duration(days: 7));

    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: _buildDatePickerTheme(context),
          child: child!,
        );
      },
    );

    if (date == null) return;

    if (!showTime) {
      onChanged(date);
      return;
    }

    final initialTime = value != null
        ? TimeOfDay(hour: value!.hour, minute: value!.minute)
        : const TimeOfDay(hour: 9, minute: 0);

    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: _buildTimePickerTheme(context),
          child: child!,
        );
      },
    );

    if (time == null) {
      onChanged(date);
      return;
    }

    onChanged(DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    ));
  }

  ThemeData _buildDatePickerTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme.copyWith(
          primary: const Color(0xFF06B6D4),
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: const Color(0xff1E293B),
        );

    return ThemeData.light().copyWith(
      colorScheme: colorScheme,
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xff1E293B),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        headerBackgroundColor: const Color(0xFF06B6D4),
        headerForegroundColor: Colors.white,
        headerHeadlineStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
        headerHelpStyle: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
        ),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFF06B6D4);
          }
          return null;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          if (states.contains(WidgetState.disabled)) {
            return const Color(0xFFCBD5E1);
          }
          return const Color(0xff1E293B);
        }),
        todayBackgroundColor: WidgetStateProperty.all(
          const Color(0xFF06B6D4).withOpacity(0.1),
        ),
        todayForegroundColor: WidgetStateProperty.all(
          const Color(0xFF06B6D4),
        ),
        yearStyle: const TextStyle(
          color: Color(0xff1E293B),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        weekdayStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        dayStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        rangePickerBackgroundColor: const Color(0xFF06B6D4).withOpacity(0.08),
        rangeSelectionBackgroundColor:
            const Color(0xFF06B6D4).withOpacity(0.15),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
        ),
        confirmButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFF06B6D4)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(const Color(0xFF64748B)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }

  ThemeData _buildTimePickerTheme(BuildContext context) {
    return ThemeData.light().copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF06B6D4),
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Color(0xff1E293B),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xff1E293B),
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hourMinuteColor: const Color(0xFFF8FAFC),
        hourMinuteTextColor: const Color(0xff1E293B),
        hourMinuteShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        dayPeriodColor: const Color(0xFFF8FAFC),
        dayPeriodTextColor: const Color(0xff1E293B),
        dayPeriodShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        dialBackgroundColor: const Color(0xFFF8FAFC),
        dialHandColor: const Color(0xFF06B6D4),
        dialTextColor: const Color(0xff1E293B),
        entryModeIconColor: const Color(0xFF06B6D4),
        helpTextStyle: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 12,
        ),
        confirmButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(const Color(0xFF06B6D4)),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        cancelButtonStyle: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(const Color(0xFF64748B)),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
