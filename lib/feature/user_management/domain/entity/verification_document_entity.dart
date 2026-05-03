import 'package:events_app/feature/common/domain/enum/app_enum.dart';
import 'package:events_app/feature/user_management/domain/entity/user_summary_entity.dart';

class VerificationDocumentEntity {
  final int? verificationDocumentId;
  final UserSummaryEntity? userSummary;
  final DocumentType? documentType;
  final String? fileUrl;
  final String? originalFileName;
  final DateTime? createdTime;

  VerificationDocumentEntity({
    this.verificationDocumentId,
    this.userSummary,
    this.documentType,
    this.fileUrl,
    this.originalFileName,
    this.createdTime,
  });

  VerificationDocumentEntity copyWith({
    int? verificationDocumentId,
    UserSummaryEntity? userSummary,
    DocumentType? documentType,
    String? fileUrl,
    String? originalFileName,
    DateTime? createdTime,
  }) {
    return VerificationDocumentEntity(
      verificationDocumentId: verificationDocumentId ?? this.verificationDocumentId,
      userSummary: userSummary ?? this.userSummary,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      originalFileName: originalFileName ?? this.originalFileName,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  String toString() {
    return 'VerificationDocumentEntity(verificationDocumentId: $verificationDocumentId, '
        'userSummary: $userSummary, documentType: $documentType, fileUrl: $fileUrl, '
        'originalFileName: $originalFileName, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationDocumentEntity &&
        other.verificationDocumentId == verificationDocumentId &&
        other.userSummary == userSummary &&
        other.documentType == documentType &&
        other.fileUrl == fileUrl &&
        other.originalFileName == originalFileName &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      verificationDocumentId,
      userSummary,
      documentType,
      fileUrl,
      originalFileName,
      createdTime,
    );
  }
}
