import 'package:flutter/material.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';

class OrganizerEventPickerSheet extends StatefulWidget {
  final List<EventSummaryEntity> events;
  final void Function(EventSummaryEntity) onSelected;
  final String title;
  final String? allOptionLabel;
  final VoidCallback? onAllSelected;
  final EventStatus? statusFilter;

  const OrganizerEventPickerSheet({
    super.key,
    required this.events,
    required this.onSelected,
    this.title = 'Chọn sự kiện',
    this.allOptionLabel,
    this.onAllSelected,
    this.statusFilter,
  });

  static Future<void> show({
    required BuildContext context,
    required List<EventSummaryEntity> events,
    required void Function(EventSummaryEntity) onSelected,
    String title = 'Chọn sự kiện',
    String? allOptionLabel,
    VoidCallback? onAllSelected,
    EventStatus? statusFilter,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => OrganizerEventPickerSheet(
        events: events,
        onSelected: onSelected,
        title: title,
        allOptionLabel: allOptionLabel,
        onAllSelected: onAllSelected,
        statusFilter: statusFilter,
      ),
    );
  }

  @override
  State<OrganizerEventPickerSheet> createState() =>
      _OrganizerEventPickerSheetState();
}

class _OrganizerEventPickerSheetState extends State<OrganizerEventPickerSheet> {
  final _searchController = TextEditingController();
  late List<EventSummaryEntity> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _applyFilter(widget.events);
  }

  List<EventSummaryEntity> _applyFilter(List<EventSummaryEntity> list) {
    if (widget.statusFilter == null) return list;
    return list.where((e) => e.status == widget.statusFilter).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    setState(() {
      final base = _applyFilter(widget.events);
      if (query.isEmpty) {
        _filtered = base;
      } else {
        final q = query.toLowerCase();
        _filtered = base.where((e) {
          return (e.title?.toLowerCase().contains(q) ?? false) ||
              (e.startTime?.toString().contains(q) ?? false);
        }).toList();
      }
    });
  }

  int get _totalCount {
    return widget.allOptionLabel != null
        ? _filtered.length + 1
        : _filtered.length;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          child: Column(
            children: [
              _buildHandle(),
              _buildHeader(),
              _buildSearch(),
              const Divider(height: 1),
              Expanded(
                child: _filtered.isEmpty && widget.allOptionLabel == null
                    ? _buildEmpty()
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: _totalCount,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 72),
                        itemBuilder: (context, index) {
                          if (widget.allOptionLabel != null && index == 0) {
                            return _buildAllTile();
                          }
                          return _buildEventTile(_filtered[
                              widget.allOptionLabel != null ? index - 1 : index]);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xff273143),
              ),
            ),
          ),
          if (_filtered.isNotEmpty || widget.allOptionLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xff06B6D4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_totalCount}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff06B6D4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: _onSearch,
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Tìm theo tên sự kiện...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            prefixIcon:
                Icon(Icons.search, size: 20, color: Colors.grey.shade400),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _searchController,
              builder: (context, value, _) {
                return value.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                        child: Icon(Icons.close, size: 18, color: Colors.grey.shade400),
                      )
                    : const SizedBox.shrink();
              },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildAllTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.checklist, color: Color(0xFF64748B), size: 22),
      ),
      title: Text(
        widget.allOptionLabel!,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xff273143),
        ),
      ),
      subtitle: Text(
        'Hiển thị tất cả sự kiện',
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xff94A3B8)),
      onTap: () {
        Navigator.pop(context);
        widget.onAllSelected?.call();
      },
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 40, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Không tìm thấy sự kiện',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(EventSummaryEntity e) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(10),
        ),
        child: e.banner != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(e.banner!, fit: BoxFit.cover),
              )
            : const Icon(Icons.event, color: Color(0xFF06B6D4), size: 22),
      ),
      title: Text(
        e.title ?? 'N/A',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Icon(Icons.people_outline, size: 12, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Text(
            '${e.totalParticipants ?? 0} người',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(width: 8),
          Icon(Icons.event, size: 12, color: Colors.grey.shade400),
          const SizedBox(width: 4),
          Text(
            e.startTime != null
                ? _formatDate(e.startTime!)
                : 'N/A',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xff94A3B8)),
      onTap: e.eventId != null
          ? () {
              Navigator.pop(context);
              widget.onSelected(e);
            }
          : null,
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
