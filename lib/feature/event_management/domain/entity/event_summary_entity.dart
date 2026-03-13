import 'package:events_app/feature/common/domain/entity/category_entity.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class EventSummaryEntity {
  final int? eventId;
  final String? title;
  final String? banner;
  final DateTime? startTime;
  final DateTime? endTime;
  final EventStatus? status;
  final int? price;
  final List<CategoryEntity>? categories;
  final int? capacity;
  final int? totalParticipants;
  

  EventSummaryEntity({
    this.eventId,
    this.title,
    this.banner,
    this.startTime,
    this.endTime,
    this.status,
    this.price,
    this.categories,
    this.capacity,
    this.totalParticipants,
  });
}
