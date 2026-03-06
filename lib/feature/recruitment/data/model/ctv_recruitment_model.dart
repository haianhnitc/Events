import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/ctv_recruitment_entity.dart';

part 'ctv_recruitment_model.freezed.dart';
part 'ctv_recruitment_model.g.dart';

@freezed
class CtvRecruitmentModel with _$CtvRecruitmentModel {
  const factory CtvRecruitmentModel({
    int? ctvRecruitmentId,
    int? eventId,
    String? roleName,
    String? description,
    String? benefit,
    @Default(0) int? quantity,
    @Default(true) bool? isOpen,
    DateTime? createdTime,
  }) = _CtvRecruitmentModel;

  factory CtvRecruitmentModel.fromJson(Map<String, dynamic> json) =>
      _$CtvRecruitmentModelFromJson(json);

  factory CtvRecruitmentModel.fromEntity(CtvRecruitmentEntity entity) {
    return CtvRecruitmentModel(
      ctvRecruitmentId: entity.ctvRecruitmentId,
      eventId: entity.eventId,
      roleName: entity.roleName,
      description: entity.description,
      benefit: entity.benefit,
      quantity: entity.quantity,
      isOpen: entity.isOpen,
      createdTime: entity.createdTime,
    );
  }
}

extension CtvRecruitmentModelExtension on CtvRecruitmentModel {
  CtvRecruitmentEntity toEntity() {
    return CtvRecruitmentEntity(
      ctvRecruitmentId: ctvRecruitmentId,
      eventId: eventId,
      roleName: roleName,
      description: description,
      benefit: benefit,
      quantity: quantity,
      isOpen: isOpen,
      createdTime: createdTime,
    );
  }
}
