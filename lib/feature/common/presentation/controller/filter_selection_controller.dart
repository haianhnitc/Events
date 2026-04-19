import 'package:get/get.dart';

abstract class FilterSelectionController {
  RxMap<int, List<String>> get selectedFilters;

  void toggleFilter(int categoryId, String optionValue);
  void clearFilters();
  void applyFilters(Map<int, List<String>> filters);
  bool isSelected(int categoryId, String optionValue);
}
