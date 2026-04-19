import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/timeline_data_entity.dart';

part 'timeline_data_model.freezed.dart';
part 'timeline_data_model.g.dart';

@freezed
class TimelineDataModel with _$TimelineDataModel {
  const factory TimelineDataModel({
    String? time,
    int? count,
  }) = _TimelineDataModel;

  factory TimelineDataModel.fromJson(Map<String, dynamic> json) =>
      _$TimelineDataModelFromJson(json);

  factory TimelineDataModel.fromEntity(TimelineDataEntity entity) {
    return TimelineDataModel(
      time: entity.time,
      count: entity.count,
    );
  }
}

extension TimelineDataModelExtension on TimelineDataModel {
  TimelineDataEntity toEntity() {
    return TimelineDataEntity(
      time: time,
      count: count,
    );
  }
}
