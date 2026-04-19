import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class CategoryLabelUtils {
  const CategoryLabelUtils._();

  static List<String> valuesFromEntities(List<CategoryEntity>? categories) {
    return _collectEntityValues(categories);
  }

  static List<CategoryDisplayGroup> groupsFromEntities(
    List<CategoryEntity>? categories,
  ) {
    final groups = <CategoryDisplayGroup>[];

    for (final category in categories ?? const <CategoryEntity>[]) {
      final categoryName = (category.name ?? '').trim();
      final values = <String>[];
      final seen = <String>{};

      for (final option in category.options ?? const []) {
        final value = (option.value ?? '').trim();
        if (value.isEmpty) continue;
        if (!seen.add(value)) continue;
        values.add(value);
      }

      if (values.isEmpty) continue;

      groups.add(
        CategoryDisplayGroup(
          name: categoryName.isNotEmpty ? categoryName : 'Danh mục',
          values: values,
        ),
      );
    }

    return groups;
  }

  static String firstFieldValue(List<CategoryEntity>? categories) {
    final values = _collectEntityValues(categories, onlyField: true);
    return values.isNotEmpty ? values.first : '--';
  }

  static String allValues(List<CategoryEntity>? categories) {
    return valuesFromEntities(categories).join(' • ');
  }

  static List<String> _collectEntityValues(
    List<CategoryEntity>? categories, {
    bool onlyField = false,
  }) {
    final values = <String>[];
    final seen = <String>{};

    for (final category in categories ?? const <CategoryEntity>[]) {
      if (onlyField && category.type != CategoryType.field) {
        continue;
      }

      for (final option in category.options ?? const []) {
        final value = (option.value ?? '').trim();
        if (value.isEmpty) continue;
        if (!seen.add(value)) continue;
        values.add(value);
      }
    }

    return values;
  }
}

class CategoryDisplayGroup {
  final String name;
  final List<String> values;

  const CategoryDisplayGroup({required this.name, required this.values});
}
