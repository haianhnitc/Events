import 'package:get/get.dart';
import 'package:events_app/feature/home/data/models/event_model.dart';
import 'package:events_app/data_mock/events_mock.dart';

class EventPageController extends GetxController {
  // explicit Rx types for clarity
  final RxList<EventModel> all = RxList<EventModel>();
  final RxString query = RxString('');
  final RxSet<String> cats = RxSet<String>();
  final RxSet<String> cities = RxSet<String>();
  final RxSet<String> formats = RxSet<String>();
  final RxSet<String> targets = RxSet<String>();
  final RxBool student5 = RxBool(false);
  final RxBool freeOnly = RxBool(false);
  final RxBool bonusPoints = RxBool(false);
  final RxString priceRange = RxString('');

  @override
  void onInit() {
    super.onInit();
    all.assignAll(eventsMock);
  }

  void setQuery(String q) => query.value = q;

  void applyFilters(Map<String, dynamic> res) {
    Set<String> toSet(dynamic v) {
      if (v == null) return <String>{};
      if (v is Set<String>) return v;
      if (v is Iterable) return v.map((e) => e.toString()).toSet();
      return {v.toString()};
    }

    cats
      ..clear()
      ..addAll(toSet(res['cats']));
    cities
      ..clear()
      ..addAll(toSet(res['cities']));
    formats
      ..clear()
      ..addAll(toSet(res['formats']));
    targets
      ..clear()
      ..addAll(toSet(res['targets']));
    freeOnly.value = (res['free'] is bool) ? res['free'] as bool : false;
    student5.value =
        (res['student5'] is bool) ? res['student5'] as bool : false;
    bonusPoints.value =
        (res['bonusPoints'] is bool) ? res['bonusPoints'] as bool : false;
    // priceRange optional
    priceRange.value =
        (res['priceRange'] is String) ? res['priceRange'] as String : '';
  }

  void clearFilters() {
    cats.clear();
    cities.clear();
    formats.clear();
    targets.clear();
    freeOnly.value = false;
    student5.value = false;
    bonusPoints.value = false;
  }

  List<String> get optionsCategories =>
      all.map((e) => e.category).toSet().toList();
  List<String> get optionsOrganizations =>
      all.map((e) => e.organization).toSet().toList();
  List<String> get optionsCities => all.map((e) => e.address).toSet().toList();
  List<String> get optionsFormats => all.map((e) => e.format).toSet().toList();
  List<String> get optionsTargets => all.map((e) => e.target).toSet().toList();

  bool get hasActiveFilters =>
      freeOnly.value ||
      student5.value ||
      bonusPoints.value ||
      cats.isNotEmpty ||
      cities.isNotEmpty ||
      formats.isNotEmpty ||
      targets.isNotEmpty;

  List<EventModel> get filtered {
    final q = query.value.trim().toLowerCase();
    return all.where((e) {
      if (freeOnly.value && e.price.toLowerCase() != 'free') return false;
      if (student5.value && e.hasStudent5Certificate != true) return false;
      if (cats.isNotEmpty && !cats.contains(e.category)) return false;
      if (cities.isNotEmpty && !cities.contains(e.address)) return false;
      if (formats.isNotEmpty && !formats.contains(e.format)) return false;
      if (targets.isNotEmpty && !targets.contains(e.target)) return false;
      // priceRange filtering (simple): if set to '0-150' or '150-300' handle accordingly
      if (priceRange.value == '0-150') {
        final priceNum =
            int.tryParse(e.price.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
        if (priceNum > 150000) return false;
      } else if (priceRange.value == '150-300') {
        final priceNum =
            int.tryParse(e.price.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
        if (priceNum < 150000 || priceNum > 300000) return false;
      }
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q) ||
          e.address.toLowerCase().contains(q);
    }).toList();
  }
}
