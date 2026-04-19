import 'package:events_app/feature/common/domain/enum/app_enum.dart';

class VerificationDocumentEntity {
  final int? verificationDocumentId;
  final int? userId;
  final DocumentType? documentType;
  final String? fileUrl;
  final String? originalFileName;
  final DateTime? createdTime;

  VerificationDocumentEntity({
    this.verificationDocumentId,
    this.userId,
    this.documentType,
    this.fileUrl,
    this.originalFileName,
    this.createdTime,
  });

  VerificationDocumentEntity copyWith({
    int? verificationDocumentId,
    int? userId,
    DocumentType? documentType,
    String? fileUrl,
    String? originalFileName,
    DateTime? createdTime,
  }) {
    return VerificationDocumentEntity(
      verificationDocumentId: verificationDocumentId ?? this.verificationDocumentId,
      userId: userId ?? this.userId,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      originalFileName: originalFileName ?? this.originalFileName,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  @override
  String toString() {
    return 'VerificationDocumentEntity(verificationDocumentId: $verificationDocumentId, '
        'userId: $userId, documentType: $documentType, fileUrl: $fileUrl, '
        'originalFileName: $originalFileName, createdTime: $createdTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VerificationDocumentEntity &&
        other.verificationDocumentId == verificationDocumentId &&
        other.userId == userId &&
        other.documentType == documentType &&
        other.fileUrl == fileUrl &&
        other.originalFileName == originalFileName &&
        other.createdTime == createdTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      verificationDocumentId,
      userId,
      documentType,
      fileUrl,
      originalFileName,
      createdTime,
    );
  }
}
