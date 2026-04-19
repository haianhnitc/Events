import 'package:events_app/data_mock/category_mock.dart';
import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/event_management/domain/entity/event_summary_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_entity.dart';
import 'package:events_app/feature/recruitment/domain/entity/ctv_recruitment_summary_entity.dart';

class CategoryFilterUtils {
  const CategoryFilterUtils._();

  static bool matchesEvent(
    EventSummaryEntity event,
    Map<int, List<String>> selectedFilters,
  ) {
    if (selectedFilters.isEmpty) return true;

    final selectedByType = _mapSelectedValuesByType(selectedFilters);
    for (final entry in selectedByType.entries) {
      if (!_matchesByType(
        type: entry.key,
        selectedValues: entry.value,
        categories: event.categories,
        price: event.price,
        certificateName: event.certificateName,
        youthUnionPoint: event.youthUnionPoint,
      )) {
        return false;
      }
    }

    return true;
  }

  static bool matchesCtv(
    CtvRecruitmentSummaryEntity recruitment,
    Map<int, List<String>> selectedFilters,
    EventSummaryEntity? relatedEvent,
  ) {
    if (selectedFilters.isEmpty) return true;

    final selectedByType = _mapSelectedValuesByType(selectedFilters);
    for (final entry in selectedByType.entries) {
      if (!_matchesByType(
        type: entry.key,
        selectedValues: entry.value,
        categories: relatedEvent?.categories,
        price: recruitment.cashRewardAmount,
        certificateName: recruitment.certificateName,
        youthUnionPoint: recruitment.youthUnionPoint,
      )) {
        return false;
      }
    }

    return true;
  }

  static bool matchesCtvByEntity(
    CtvRecruitmentEntity recruitment,
    Map<int, List<String>> selectedFilters,
    EventSummaryEntity? relatedEvent,
  ) {
    if (selectedFilters.isEmpty) return true;

    final selectedByType = _mapSelectedValuesByType(selectedFilters);
    for (final entry in selectedByType.entries) {
      if (!_matchesByType(
        type: entry.key,
        selectedValues: entry.value,
        categories: relatedEvent?.categories,
        price: recruitment.cashRewardAmount,
        certificateName: recruitment.certificateName,
        youthUnionPoint: recruitment.youthUnionPoint,
      )) {
        return false;
      }
    }

    return true;
  }

  static Map<CategoryType, Set<String>> _mapSelectedValuesByType(
    Map<int, List<String>> selectedFilters,
  ) {
    final selectedByType = <CategoryType, Set<String>>{};
    for (final entry in selectedFilters.entries) {
      if (entry.value.isEmpty) continue;
      final category = _findCategoryById(entry.key);

      final categoryType = category.type;
      if (categoryType == null) continue;

      selectedByType.putIfAbsent(categoryType, () => <String>{});
      selectedByType[categoryType]!
          .addAll(entry.value.map((value) => value.toLowerCase()));
    }
    return selectedByType;
  }

  static CategoryEntity _findCategoryById(int categoryId) {
    for (final category in categoriesMock) {
      if (category.categoryId == categoryId) return category;
    }

    return CategoryEntity();
  }

  static bool _matchesByType({
    required CategoryType type,
    required Set<String> selectedValues,
    required List<CategoryEntity>? categories,
    required int? price,
    required String? certificateName,
    required int? youthUnionPoint,
  }) {
    switch (type) {
      case CategoryType.price:
        return _matchesPrice(selectedValues, price);
      case CategoryType.criterion:
        return _matchesCriterion(
            selectedValues, certificateName, youthUnionPoint);
      default:
        final optionValues = <String>{};
        for (final category in categories ?? const <CategoryEntity>[]) {
          if (category.type != type) continue;
          for (final option in category.options ?? const []) {
            final value = option.value;
            if (value == null || value.isEmpty) continue;
            optionValues.add(value.toLowerCase());
          }
        }

        if (optionValues.isEmpty) return false;
        return selectedValues.any(optionValues.contains);
    }
  }

  static bool _matchesPrice(Set<String> selectedValues, int? price) {
    for (final value in selectedValues) {
      if (value == '0' || value == 'miễn phí') {
        if ((price ?? 0) == 0) return true;
        continue;
      }

      if (value == '0-150000' || value == '0 - 150,000đ') {
        if ((price ?? 0) > 0 && (price ?? 0) <= 150000) return true;
        continue;
      }

      if (value == '150000-300000' || value == '150,000đ - 300,000đ') {
        if ((price ?? 0) > 150000 && (price ?? 0) <= 300000) return true;
        continue;
      }

      if (value == '300000+' || value == 'trên 300,000đ') {
        if ((price ?? 0) > 300000) return true;
      }
    }

    return false;
  }

  static bool _matchesCriterion(
    Set<String> selectedValues,
    String? certificateName,
    int? youthUnionPoint,
  ) {
    if (selectedValues.isEmpty) return true;

    final hasCertificate = (certificateName ?? '').trim().isNotEmpty;
    final hasYouthUnionPoint = (youthUnionPoint ?? 0) > 0;

    for (final value in selectedValues) {
      final lower = value.toLowerCase();

      if (lower == 'certificate' || lower == 'chứng chỉ 5 tốt') {
        if (!hasCertificate) return false;
      } else if (lower == 'point_conduct' || lower == 'cộng điểm đoàn') {
        if (!hasYouthUnionPoint) return false;
      }
    }
    return true;
  }
}
