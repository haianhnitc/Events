import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/presentation/controller/filter_selection_controller.dart';
import 'package:flutter/material.dart';

class EventFilterBottomSheet extends StatelessWidget {
  final FilterSelectionController controller;
  final List<CategoryEntity> categories;
  final bool isEvent;

  const EventFilterBottomSheet({
    super.key,
    required this.controller,
    this.categories = const [],
    this.isEvent = true,
  });

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.72;
    final activeColor =
        isEvent ? const Color(0xff06B6D4) : const Color(0xffDB0025);

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xffD5D9E2),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              _buildHeader(context),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: categories
                        .map(
                          (category) => _CategorySection(
                            category: category,
                            accentColor: activeColor,
                            isSelected: (value) {
                              final categoryId = category.categoryId;
                              if (categoryId == null) return false;
                              return controller.isSelected(categoryId, value);
                            },
                            onToggle: (value) {
                              final categoryId = category.categoryId;
                              if (categoryId == null) return;
                              controller.toggleFilter(categoryId, value);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              _buildFooter(context, activeColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Bộ lọc',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xff273143),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, size: 20, color: Color(0xff67688C)),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, Color applyColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                side: const BorderSide(color: Color(0xffD5D9E2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                controller.clearFilters();
              },
              child: const Text(
                'Xóa bộ lọc',
                style: TextStyle(
                  color: Color(0xff273143),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                side: BorderSide(color: applyColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Đóng',
                style: TextStyle(
                  color: applyColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final CategoryEntity category;
  final Color accentColor;
  final bool Function(String value) isSelected;
  final ValueChanged<String> onToggle;

  const _CategorySection({
    required this.category,
    required this.accentColor,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final options = category.options ?? [];
    if (options.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          child: Text(
            category.name ?? '',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xff273143),
            ),
          ),
        ),
        ...options.map((option) {
          final value = option.value ?? '';
          if (value.trim().isEmpty) {
            return const SizedBox.shrink();
          }

          return InkWell(
            onTap: () => onToggle(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected(value),
                    activeColor: accentColor,
                    onChanged: (_) => onToggle(value),
                  ),
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xff273143),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
