import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import '../../domain/entity/verification_document_entity.dart';

part 'verification_document_model.freezed.dart';
part 'verification_document_model.g.dart';

@freezed
class VerificationDocumentModel with _$VerificationDocumentModel {
  const factory VerificationDocumentModel({
    int? verificationDocumentId,
    int? userId,
    DocumentType? documentType,
    String? fileUrl,
    String? originalFileName,
    DateTime? createdTime,
  }) = _VerificationDocumentModel;

  factory VerificationDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$VerificationDocumentModelFromJson(json);

  factory VerificationDocumentModel.fromEntity(
      VerificationDocumentEntity entity) {
    return VerificationDocumentModel(
      verificationDocumentId: entity.verificationDocumentId,
      userId: entity.userId,
      documentType: entity.documentType,
      fileUrl: entity.fileUrl,
      originalFileName: entity.originalFileName,
      createdTime: entity.createdTime,
    );
  }
}

extension VerificationDocumentModelExtension on VerificationDocumentModel {
  VerificationDocumentEntity toEntity() {
    return VerificationDocumentEntity(
      verificationDocumentId: verificationDocumentId,
      userId: userId,
      documentType: documentType,
      fileUrl: fileUrl,
      originalFileName: originalFileName,
      createdTime: createdTime,
    );
  }
}
