import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/application_answer_entity.dart';

part 'application_answer_model.freezed.dart';
part 'application_answer_model.g.dart';

@freezed
class ApplicationAnswerModel with _$ApplicationAnswerModel {
  const factory ApplicationAnswerModel({
    int? applicationAnswerId,
    int? eventStaffApplicationId,
    int? requirementQuestionId,
    String? answerValue,
  }) = _ApplicationAnswerModel;

  factory ApplicationAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationAnswerModelFromJson(json);

  factory ApplicationAnswerModel.fromEntity(ApplicationAnswerEntity entity) {
    return ApplicationAnswerModel(
      applicationAnswerId: entity.applicationAnswerId,
      eventStaffApplicationId: entity.eventStaffApplicationId,
      requirementQuestionId: entity.requirementQuestionId,
      answerValue: entity.answerValue,
    );
  }
}

extension ApplicationAnswerModelExtension on ApplicationAnswerModel {
  ApplicationAnswerEntity toEntity() {
    return ApplicationAnswerEntity(
      applicationAnswerId: applicationAnswerId,
      eventStaffApplicationId: eventStaffApplicationId,
      requirementQuestionId: requirementQuestionId,
      answerValue: answerValue,
    );
  }
}
