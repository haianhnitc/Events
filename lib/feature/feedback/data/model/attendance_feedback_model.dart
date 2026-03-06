import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/attendance_feedback_entity.dart';

part 'attendance_feedback_model.freezed.dart';
part 'attendance_feedback_model.g.dart';

@freezed
class AttendanceFeedbackModel with _$AttendanceFeedbackModel {
  const factory AttendanceFeedbackModel({
    int? attendanceFeedbackId,
    int? eventParticipantId,
    String? comment,
    DateTime? createdTime,
  }) = _AttendanceFeedbackModel;

  factory AttendanceFeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFeedbackModelFromJson(json);

  factory AttendanceFeedbackModel.fromEntity(AttendanceFeedbackEntity entity) {
    return AttendanceFeedbackModel(
      attendanceFeedbackId: entity.attendanceFeedbackId,
      eventParticipantId: entity.eventParticipantId,
      comment: entity.comment,
      createdTime: entity.createdTime,
    );
  }
}

extension AttendanceFeedbackModelExtension on AttendanceFeedbackModel {
  AttendanceFeedbackEntity toEntity() {
    return AttendanceFeedbackEntity(
      attendanceFeedbackId: attendanceFeedbackId,
      eventParticipantId: eventParticipantId,
      comment: comment,
      createdTime: createdTime,
    );
  }
}
