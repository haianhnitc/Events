import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/question_option_entity.dart';

part 'question_option_model.freezed.dart';
part 'question_option_model.g.dart';

@freezed
class QuestionOptionModel with _$QuestionOptionModel {
  const factory QuestionOptionModel({
    int? optionId,
    int? questionId,
    String? optionValue,
  }) = _QuestionOptionModel;

  factory QuestionOptionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionModelFromJson(json);

  factory QuestionOptionModel.fromEntity(QuestionOptionEntity entity) {
    return QuestionOptionModel(
      optionId: entity.optionId,
      questionId: entity.questionId,
      optionValue: entity.optionValue,
    );
  }
}

extension QuestionOptionModelExtension on QuestionOptionModel {
  QuestionOptionEntity toEntity() {
    return QuestionOptionEntity(
      optionId: optionId,
      questionId: questionId,
      optionValue: optionValue,
    );
  }
}
