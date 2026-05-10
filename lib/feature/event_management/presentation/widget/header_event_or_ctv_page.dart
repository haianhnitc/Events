import 'package:flutter/material.dart';

class HeaderEventOrCtvPage extends StatelessWidget {
  const HeaderEventOrCtvPage({
    super.key,
    required this.isEvent,
    required this.onFilterTap,
    required this.onSearchChanged,
    this.hasActiveFilter = false,
    this.searchController,
  });

  final bool isEvent;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onSearchChanged;
  final bool hasActiveFilter;
  final TextEditingController? searchController;

  Color get _primaryColor =>
      isEvent ? const Color(0xFF06B6D4) : const Color(0xFFDB0025);

  String get _title => isEvent ? 'Sự kiện' : 'Việc làm CTV';
  String get _subtitle => isEvent
      ? 'Khám phá và tham gia sự kiện'
      : 'Tìm cơ hội làm CTV, tích lũy kinh nghiệm';
  String get _hintText =>
      isEvent ? 'Tìm kiếm sự kiện...' : 'Tìm kiếm việc làm...';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _primaryColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSearchBar()),
              const SizedBox(width: 10),
              _buildFilterButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                hintText: _hintText,
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: onFilterTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: hasActiveFilter
              ? Colors.white.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.tune_outlined,
              size: 18,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              hasActiveFilter ? 'Lọc' : 'Bộ lọc',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (hasActiveFilter) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
