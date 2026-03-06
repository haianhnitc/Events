import 'package:events_app/data_mock/events_mock.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/data_mock/venues_mock.dart';
import 'package:events_app/data_mock/users_mock.dart';
import 'package:events_app/feature/event_management/data/model/event_model.dart';
import 'package:events_app/feature/venue/data/model/venue_model.dart';
import 'package:events_app/feature/user_management/data/model/user_model.dart';
import 'package:get/get.dart';

class EventPageController extends GetxController {
  final RxList<EventModel> all = RxList<EventModel>();
  final RxList<VenueModel> venues = RxList<VenueModel>();
  final RxList<UserModel> users = RxList<UserModel>();
  final RxString query = RxString('');
  final RxSet<EventStatus> statuses = RxSet<EventStatus>();
  final RxSet<EventRecruitmentType> recruitmentTypes =
      RxSet<EventRecruitmentType>();

  @override
  void onInit() {
    super.onInit();
    all.assignAll(eventsMock);
    venues.assignAll(venuesMock);
    users.assignAll(usersMock);
  }

  VenueModel? getVenue(int? venueId) {
    if (venueId == null) return null;
    try {
      return venues.firstWhere((v) => v.venueId == venueId);
    } catch (_) {
      return null;
    }
  }

  UserModel? getUser(int? userId) {
    if (userId == null) return null;
    try {
      return users.firstWhere((u) => u.userId == userId);
    } catch (_) {
      return null;
    }
  }

  void setQuery(String q) => query.value = q;

  void applyFilters(Map<String, dynamic> res) {
    Set<T> toSet<T>(dynamic v) {
      if (v == null) return <T>{};
      if (v is Set<T>) return v;
      if (v is Iterable) return v.whereType<T>().toSet();
      return <T>{};
    }

    statuses
      ..clear()
      ..addAll(toSet<EventStatus>(res['statuses']));

    recruitmentTypes
      ..clear()
      ..addAll(toSet<EventRecruitmentType>(res['recruitmentTypes']));
  }

  void clearFilters() {
    statuses.clear();
    recruitmentTypes.clear();
  }

  List<EventStatus> get optionsStatuses =>
      all.map((e) => e.status).whereType<EventStatus>().toSet().toList();

  List<EventRecruitmentType> get optionsRecruitmentTypes => all
      .map((e) => e.recruitmentType)
      .whereType<EventRecruitmentType>()
      .toSet()
      .toList();

  bool get hasActiveFilters =>
      statuses.isNotEmpty || recruitmentTypes.isNotEmpty;

  List<EventModel> get filtered {
    final q = query.value.trim().toLowerCase();

    return all.where((e) {
      final status = e.status;
      final type = e.recruitmentType;
      final title = (e.title ?? '').toLowerCase();
      final description = (e.description ?? '').toLowerCase();

      if (statuses.isNotEmpty &&
          (status == null || !statuses.contains(status))) {
        return false;
      }
      if (recruitmentTypes.isNotEmpty &&
          (type == null || !recruitmentTypes.contains(type))) {
        return false;
      }

      if (q.isEmpty) return true;
      return title.contains(q) || description.contains(q);
    }).toList();
  }
}
