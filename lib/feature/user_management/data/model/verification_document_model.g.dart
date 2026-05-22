// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VerificationDocumentModelImpl _$$VerificationDocumentModelImplFromJson(
        Map<String, dynamic> json) =>
    _$VerificationDocumentModelImpl(
      verificationDocumentId: (json['verificationDocumentId'] as num?)?.toInt(),
      userSummary: json['userSummary'] == null
          ? null
          : UserSummaryModel.fromJson(
              json['userSummary'] as Map<String, dynamic>),
      documentType:
          $enumDecodeNullable(_$DocumentTypeEnumMap, json['documentType']),
      fileUrl: json['fileUrl'] as String?,
      originalFileName: json['originalFileName'] as String?,
      createdTime: json['createdTime'] == null
          ? null
          : DateTime.parse(json['createdTime'] as String),
    );

Map<String, dynamic> _$$VerificationDocumentModelImplToJson(
        _$VerificationDocumentModelImpl instance) =>
    <String, dynamic>{
      'verificationDocumentId': instance.verificationDocumentId,
      'userSummary': instance.userSummary,
      'documentType': _$DocumentTypeEnumMap[instance.documentType],
      'fileUrl': instance.fileUrl,
      'originalFileName': instance.originalFileName,
      'createdTime': instance.createdTime?.toIso8601String(),
    };

const _$DocumentTypeEnumMap = {
  DocumentType.businessLicense: 'BUSINESS_LICENSE',
  DocumentType.universityDecision: 'UNIVERSITY_DECISION',
  DocumentType.clubCertificate: 'CLUB_CERTIFICATE',
  DocumentType.taxCode: 'TAX_CODE',
  DocumentType.other: 'OTHER',
};
