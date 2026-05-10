import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/presentation/controller/filter_selection_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

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

  Color get _accentColor =>
      isEvent ? const Color(0xFF06B6D4) : const Color(0xFFDB0025);

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.78;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFF4F6F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 16, 14),
            decoration: BoxDecoration(
              color: _accentColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Bộ lọc',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(() {
                  final count = controller.selectedFilters.values
                      .expand((v) => v)
                      .where((v) => v.trim().isNotEmpty)
                      .length;
                  if (count == 0) return const SizedBox.shrink();
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxHeight - 140),
              child: ListView(
                padding: const EdgeInsets.all(16),
                shrinkWrap: true,
                children: categories
                    .map((category) => _CategorySection(
                          category: category,
                          accentColor: _accentColor,
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
                        ))
                    .toList(),
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                side: const BorderSide(color: Color(0xFFD5D9E2)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: const Color(0xff273143),
              ),
              onPressed: () {
                controller.clearFilters();
              },
              child: const Text(
                'Xóa lọc',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Áp dụng',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category.name ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff273143),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((option) {
                final value = option.value ?? '';
                if (value.trim().isEmpty) return const SizedBox.shrink();
                return _PillChip(
                  label: value,
                  isSelected: isSelected(value),
                  accentColor: accentColor,
                  onTap: () => onToggle(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PillChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _PillChip({
    required this.label,
    required this.isSelected,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? accentColor : const Color(0xFFD5D9E2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xff67688C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
