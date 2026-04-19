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
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          isEvent ? 'Sự kiện' : 'Việc làm',
          style: TextStyle(
            fontSize: 20,
            height: 28 / 20,
            fontWeight: FontWeight.w700,
            color: isEvent ? const Color(0xff06B6D4) : const Color(0xffDB0025),
          ),
        ),
        Text(
          isEvent
              ? 'Khám phá và tham gia sự kiện'
              : 'Tìm cơ hội làm CTV, tích lũy kinh nghiệm',
          style: const TextStyle(
            fontSize: 12,
            height: 20 / 12,
            fontWeight: FontWeight.w400,
            color: Color(0xff67688C),
          ),
        ),
        const SizedBox(height: 16),
        _buildSearchBar(isEvent),
        const SizedBox(height: 16),
        _buildFilterButton(isEvent),
        const SizedBox(height: 16),
      ],
    );
  }

  _buildSearchBar(bool isEvent) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xffF9FAFB),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search_outlined,
            color: Color(0xff67688C),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearchChanged,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              maxLines: 1,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText:
                    isEvent ? 'Tìm kiếm sự kiện...' : 'Tìm kiếm việc làm...',
                hintStyle: const TextStyle(
                    color: Color(0xff67688C),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildFilterButton(bool isEvent) {
    final activeColor =
        isEvent ? const Color(0xff06B6D4) : const Color(0xffDB0025);

    return GestureDetector(
      onTap: onFilterTap,
      child: Container(
        height: 32,
        width: hasActiveFilter ? 118 : 89,
        decoration: BoxDecoration(
          color: hasActiveFilter
              ? activeColor.withOpacity(0.12)
              : const Color(0xffF8F8FC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1.71,
            color: hasActiveFilter
                ? activeColor
                : const Color(0xff273143).withOpacity(0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.tune_outlined,
              size: 20,
              color: hasActiveFilter ? activeColor : const Color(0xff273143),
            ),
            const SizedBox(width: 8),
            Text(
              hasActiveFilter ? 'Đang lọc' : 'Bộ lọc',
              style: TextStyle(
                fontSize: 14,
                height: 20 / 14,
                fontWeight: FontWeight.w500,
                color: hasActiveFilter ? activeColor : const Color(0xff273143),
              ),
            ),
            if (hasActiveFilter) ...[
              const SizedBox(width: 6),
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
