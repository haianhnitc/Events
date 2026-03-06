import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/report_entity.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  const factory ReportModel({
    int? reportId,
    int? userId,
    String? title,
    String? name,
    String? email,
    String? phoneNumber,
    String? description,
    DateTime? createdTime,
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      reportId: entity.reportId,
      userId: entity.userId,
      title: entity.title,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      description: entity.description,
      createdTime: entity.createdTime,
    );
  }
}

extension ReportModelExtension on ReportModel {
  ReportEntity toEntity() {
    return ReportEntity(
      reportId: reportId,
      userId: userId,
      title: title,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      description: description,
      createdTime: createdTime,
    );
  }
}
