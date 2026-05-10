import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/organizer/presentation/widget/organizer_event_picker.dart';
import 'package:flutter/material.dart';

class OrganizerEventDropdownField extends StatelessWidget {
  final List<EventSummaryEntity> events;
  final EventSummaryEntity? selectedEvent;
  final ValueChanged<EventSummaryEntity?> onChanged;
  final bool showAllOption;
  final String hint;

  const OrganizerEventDropdownField({
    super.key,
    required this.events,
    required this.selectedEvent,
    required this.onChanged,
    this.showAllOption = true,
    this.hint = 'Chọn sự kiện',
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => _showPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF06B6D4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.event,
                size: 16,
                color: Color(0xFF06B6D4),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedEvent?.title ?? hint,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: selectedEvent != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: selectedEvent != null
                          ? const Color(0xff273143)
                          : const Color(0xff94A3B8),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (selectedEvent?.startTime != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(selectedEvent!.startTime!),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    OrganizerEventPickerSheet.show(
      context: context,
      events: events,
      onSelected: (e) => onChanged(e),
      title: 'Chọn sự kiện',
      allOptionLabel: showAllOption ? 'Tất cả sự kiện' : null,
      onAllSelected: showAllOption ? () => onChanged(null) : null,
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
