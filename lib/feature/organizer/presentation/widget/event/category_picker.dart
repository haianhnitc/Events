import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/organizer/presentation/widget/event/category_option_data.dart';

class CategoryOptionChip extends StatelessWidget {
  final CategoryOptionData option;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryOptionChip({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF06B6D4).withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF06B6D4) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          option.label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? const Color(0xFF06B6D4) : const Color(0xff64748B),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class CategoryOptionGroup extends StatelessWidget {
  final String groupName;
  final List<CategoryOptionData> options;
  final RxList<int> selectedIds;
  final void Function(int) onToggle;

  const CategoryOptionGroup({
    super.key,
    required this.groupName,
    required this.options,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          groupName,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xff273143),
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: options.map((opt) {
                final isSelected = selectedIds.contains(opt.id);
                return CategoryOptionChip(
                  option: opt,
                  isSelected: isSelected,
                  onTap: () => onToggle(opt.id),
                );
              }).toList(),
            )),
      ],
    );
  }
}

class CategoryPickerStep extends StatelessWidget {
  final RxList<CategoryEntity> categories;
  final RxList<int> selectedCategoryOptionIds;
  final RxBool isLoading;
  final void Function(int) onToggle;

  const CategoryPickerStep({
    super.key,
    required this.categories,
    required this.selectedCategoryOptionIds,
    required this.isLoading,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCard([
            const _StepTitle('Danh mục sự kiện'),
            const SizedBox(height: 8),
            const Text(
              'Chọn các danh mục phù hợp để sự kiện dễ tìm thấy hơn',
              style: TextStyle(fontSize: 12, color: Color(0xff64748B)),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (isLoading.value && categories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (categories.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(
                    child: Text(
                      'Không có danh mục nào',
                      style: TextStyle(color: Color(0xff64748B)),
                    ),
                  ),
                );
              }
              return Column(
                children: categories.map((cat) {
                  final opts = cat.options ?? [];
                  if (opts.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CategoryOptionGroup(
                      groupName: cat.name ?? 'Danh mục',
                      options: opts
                          .map((o) => CategoryOptionData(
                                id: o.categoryOptionId ?? 0,
                                label: o.value ?? '',
                              ))
                          .toList(),
                      selectedIds: selectedCategoryOptionIds,
                      onToggle: onToggle,
                    ),
                  );
                }).toList(),
              );
            }),
          ]),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _StepTitle extends StatelessWidget {
  final String title;
  const _StepTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xff273143),
      ),
    );
  }
}
